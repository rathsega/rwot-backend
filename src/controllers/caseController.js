const { all } = require("axios");
const pool = require("../db");
const { sendEmail, sendWhatsApp } = require("../utils/notifications");
const { sendEmailNotification } = require("../utils/emailHelper");

// Helper function to get cold case threshold from app_settings
const getColdCaseThreshold = async () => {
  try {
    const result = await pool.query(
      "SELECT setting_value FROM app_settings WHERE setting_key = 'cold_case_threshold_hours'"
    );
    return parseInt(result.rows[0]?.setting_value || 48, 10);
  } catch (err) {
    console.error("Error fetching cold case threshold:", err);
    return 48; // Default fallback
  }
};

// Helper function to log status changes
const logStatusChange = async (caseid, oldStatus, newStatus, changedBy, remarks = null) => {
  if (oldStatus === newStatus) return; // No change, don't log
  
  try {
    await pool.query(
      `INSERT INTO status_change_log (caseid, old_status, new_status, changed_by, changed_at, remarks)
       VALUES ($1, $2, $3, $4, NOW(), $5)`,
      [caseid, oldStatus, newStatus, changedBy, remarks]
    );
  } catch (err) {
    console.error("Error logging status change:", err);
    // Don't throw - status logging failure shouldn't block the main operation
  }
};

// Create case
exports.createCase = async (req, res) => {
  const {
    caseid,
    companyname,
    clientname,
    role,
    status,
    companyemail,
    spocemail,
    spocname,
    spocphonenumber,
    location,
    turnover,
    leadsource,
    date,
    time,
    createddate,
    assigneddate,
    assignee,
    comments,
    productname,
    assigned_to_name,
    phonenumber,
    kamAssignee,
    bankname,
    stage
  } = req.body;

  const createdby = req.user.id;
  const finalLeadSource = role === "Individual" ? "Website" : leadsource;

  try {
    await pool.query(
      `INSERT INTO cases (caseid, companyname, clientname, role, status, createdby, productname, assigned_to_name, assignee, stage, bankname, updatedat, spocname, spocemail, spocphonenumber, leadsource, date, "time", phonenumber, turnover, location, companyemail, createddate, assigneddate)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,NOW(),$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23)`,
      [
        caseid,
        companyname,
        clientname,
        role,
        status || "Open",
        createdby,
        productname || null,
        assigned_to_name || null,
        assignee || null,
        stage || "Documentation",
        bankname || null,
        spocname,
        spocemail,
        spocphonenumber,
        finalLeadSource,
        date,
        time,
        phonenumber,
        turnover,
        location,
        companyemail,
        createddate || new Date(),
        assigneddate || new Date()
      ]
    );

    if (kamAssignee) {
      await pool.query(
        `INSERT INTO case_assignments (caseid, assigned_to, role)
         VALUES ($1, $2, $3)
         ON CONFLICT (caseid, role) DO UPDATE SET assigned_to = EXCLUDED.assigned_to`,
        [caseid, kamAssignee, "KAM"]
      );

      const kamUser = await pool.query("SELECT email, phone FROM users WHERE id = $1", [kamAssignee]);
      const kamEmail = kamUser.rows[0].email;
      const kamPhone = kamUser.rows[0].phone;

      await sendEmailNotification({
        from: process.env.GOOGLE_APP_EMAIL,
        to: kamEmail,
        subject: "New Lead Assigned",
        text: `You have a new case assigned:

Case ID: ${caseid}
Company Name: ${companyname}
Client Name: ${clientname}
Meeting Date: ${date} ${time}
Meeting Location: ${location}

Please check the RWOT portal for more details.

Regards,
RWOT Team`
      });
      // await sendWhatsApp(kamPhone, `New RWOT case ${caseid} has been assigned to you.`);
    }

    await pool.query(
      `INSERT INTO case_assignments (caseid, assigned_to, role)
       VALUES ($1, $2, $3)
       ON CONFLICT (caseid, role) DO UPDATE SET assigned_to = EXCLUDED.assigned_to`,
      [caseid, createdby, "Telecaller"]
    );

    const safeComments = Array.isArray(comments) ? comments : [];
    if (safeComments.length > 0) {
      await Promise.all(
        safeComments.map(c =>
          pool.query(
            `INSERT INTO comments (caseid, comment, commentby, date) VALUES ($1,$2,$3,$4)`,
            [caseid, c.comment || c.text || "", c.commentby || "System", c.date || new Date().toISOString()]
          )
        )
      );
    }

    // Log initial status creation
    await logStatusChange(caseid, null, status || "Open", createdby, "Case created");

    // Invalidate cache for all users since new case is created
    if (global.caseCache) {
      global.caseCache.clear();
    }

    res.status(201).json({ message: "Case created" });
  } catch (err) {
    console.error("Create Case Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Get case counts by status for dashboard tabs
exports.getCaseCounts = async (req, res) => {
  const userId = req.user.id;
  
  try {
    // Get cold case threshold from app_settings
    const coldThresholdHours = await getColdCaseThreshold();
    
    const userResult = await pool.query(
      `SELECT users.*, roles.rolename FROM users JOIN roles ON users.roleid = roles.id WHERE users.id = $1`,
      [userId]
    );
    const user = userResult.rows[0];

    let whereClause = "";
    let values = [];
    let paramIndex = 1;

    // Build WHERE clause based on role
    if (user.rolename === "Individual") {
      whereClause = ` WHERE c.role = 'Individual' AND LOWER(c.spocemail) = LOWER($${paramIndex})`;
      values.push(user.email);
      paramIndex++;
    } else if (user.rolename === "KAM") {
      whereClause = ` WHERE EXISTS (SELECT 1 FROM case_assignments ca WHERE ca.caseid = c.caseid AND ca.role = 'KAM' AND ca.assigned_to = $${paramIndex})`;
      values.push(userId);
      paramIndex++;
    } else if (user.rolename === "Telecaller") {
      whereClause = ` WHERE c.createdby = $${paramIndex}`;
      values.push(userId);
      paramIndex++;
    } else if (user.rolename === "Operations") {
      whereClause = ` WHERE LOWER(c.status) IN (
        'open', 'meeting done', 'documentation initiated', 'documentation in progress', 
        'underwriting', 'one pager', 'banker review', 'no requirement',
        'accept', 'login', 'pd', 'sanctioned', 'disbursement', 'done', 'rejected'
      )`;
    }
    // Admin and UW see all cases (no WHERE clause for counts)

    // Cold case logic - cases inactive for more than threshold hours
    // Exclude: open, no requirement, done, rejected, meeting done
    const coldExcludedStatuses = ['open', 'no requirement', 'done', 'rejected', 'meeting done'];
    
    // Build cold case condition to exclude from regular status counts
    const coldCaseCondition = `(
      LOWER(c.status) NOT IN (${coldExcludedStatuses.map((_, i) => `$${paramIndex + i}`).join(', ')})
      AND c.status_updated_on IS NOT NULL 
      AND c.status_updated_on < NOW() - INTERVAL '${coldThresholdHours} hours'
    )`;
    
    // Count regular cases (excluding cold cases)
    const regularWhereClause = whereClause 
      ? `${whereClause} AND NOT ${coldCaseCondition}`
      : `WHERE NOT ${coldCaseCondition}`;
    
    const regularCountQuery = `
      SELECT 
        c.status,
        COUNT(DISTINCT c.caseid) as count
      FROM cases c
      ${regularWhereClause}
      GROUP BY c.status
    `;
    
    const regularValues = [...values, ...coldExcludedStatuses];
    const result = await pool.query(regularCountQuery, regularValues);
    
    // Convert to object for easier frontend use
    const counts = {};
    let total = 0;
    result.rows.forEach(row => {
      counts[row.status] = parseInt(row.count, 10);
      total += parseInt(row.count, 10);
    });
    
    // Count cold cases separately
    const coldWhereClause = whereClause 
      ? `${whereClause} AND ${coldCaseCondition}`
      : `WHERE ${coldCaseCondition}`;
    
    const coldCountQuery = `
      SELECT COUNT(DISTINCT c.caseid) as count
      FROM cases c
      ${coldWhereClause}
    `;
    
    const coldResult = await pool.query(coldCountQuery, regularValues);
    const coldCount = parseInt(coldResult.rows[0]?.count || 0, 10);
    counts.cold = coldCount;
    
    // Total includes both regular and cold cases
    counts.total = total + coldCount;

    res.json({ counts, coldThresholdHours });
  } catch (err) {
    console.error("Get Case Counts Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Get dashboard statistics (counts, ratios) - optimized endpoint with filter support
exports.getDashboardStats = async (req, res) => {
  try {
    const { dateFilter, dateFrom, dateTo } = req.query;
    
    // Build date filter condition
    const whereConditions = [];
    const values = [];
    let paramIndex = 1;
    
    // Date filter logic
    if (dateFilter && dateFilter !== 'all') {
      const now = new Date();
      let filterStart, filterEnd;
      
      switch(dateFilter) {
        case 'today':
          filterStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
          filterEnd = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);
          break;
        case 'yesterday':
          filterStart = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 1);
          filterEnd = new Date(now.getFullYear(), now.getMonth(), now.getDate());
          break;
        case 'last7days':
          filterStart = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 7);
          filterEnd = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);
          break;
        case 'last30days':
          filterStart = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 30);
          filterEnd = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);
          break;
        case 'thisweek':
          const dayOfWeek = now.getDay();
          filterStart = new Date(now.getFullYear(), now.getMonth(), now.getDate() - dayOfWeek);
          filterEnd = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);
          break;
        case 'thismonth':
          filterStart = new Date(now.getFullYear(), now.getMonth(), 1);
          filterEnd = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);
          break;
        case 'thisyear':
          filterStart = new Date(now.getFullYear(), 0, 1);
          filterEnd = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);
          break;
        case 'financialyear':
          filterStart = now.getMonth() >= 3
            ? new Date(now.getFullYear(), 3, 1)
            : new Date(now.getFullYear() - 1, 3, 1);
          filterEnd = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);
          break;
        case 'lastfinancialyear':
          filterStart = now.getMonth() >= 3
            ? new Date(now.getFullYear() - 1, 3, 1)
            : new Date(now.getFullYear() - 2, 3, 1);
          filterEnd = now.getMonth() >= 3
            ? new Date(now.getFullYear(), 3, 1)
            : new Date(now.getFullYear() - 1, 3, 1);
          break;
        case 'custom':
          if (dateFrom) {
            filterStart = new Date(dateFrom);
          }
          if (dateTo) {
            filterEnd = new Date(dateTo);
            filterEnd.setDate(filterEnd.getDate() + 1); // Include the end date
          }
          break;
      }
      
      if (filterStart) {
        whereConditions.push(`c.createddate >= $${paramIndex}`);
        values.push(filterStart);
        paramIndex++;
      }
      if (filterEnd) {
        whereConditions.push(`c.createddate < $${paramIndex}`);
        values.push(filterEnd);
        paramIndex++;
      }
    }
    
    const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';
    
    // Get current date info for time-based counts
    const now = new Date();
    const todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const last7DaysStart = new Date(todayStart);
    last7DaysStart.setDate(last7DaysStart.getDate() - 7);
    const last30DaysStart = new Date(todayStart);
    last30DaysStart.setDate(last30DaysStart.getDate() - 30);
    
    // Financial year starts April 1st
    const financialYearStart = now.getMonth() >= 3
      ? new Date(now.getFullYear(), 3, 1)
      : new Date(now.getFullYear() - 1, 3, 1);

    // Single query to get all counts with filter
    const statsQuery = `
      SELECT 
        COUNT(*) FILTER (WHERE DATE(c.createddate) = CURRENT_DATE) as today_count,
        COUNT(*) FILTER (WHERE c.createddate >= $${paramIndex}) as last_7_days_count,
        COUNT(*) FILTER (WHERE c.createddate >= $${paramIndex + 1}) as last_30_days_count,
        COUNT(*) FILTER (WHERE c.createddate >= $${paramIndex + 2}) as financial_year_count,
        COUNT(*) as total_leads,
        COUNT(*) FILTER (WHERE LOWER(c.status) IN ('meeting done', 'documentation initiated', 'documentation in progress', 'underwriting', 'one pager', 'banker review', 'login', 'pd', 'sanctioned', 'disbursement', 'done')) as meeting_done,
        COUNT(*) FILTER (WHERE LOWER(c.status) IN ('documentation initiated', 'documentation in progress', 'underwriting', 'one pager', 'banker review', 'login', 'pd', 'sanctioned', 'disbursement', 'done')) as documentation_initiated
      FROM cases c
      ${whereClause}
    `;

    const statsResult = await pool.query(statsQuery, [...values, last7DaysStart, last30DaysStart, financialYearStart]);
    const statsRow = statsResult.rows[0];

    // Get status counts with filter
    const statusQuery = `
      SELECT c.status, COUNT(*) as count
      FROM cases c
      ${whereClause}
      GROUP BY c.status
    `;
    const statusResult = await pool.query(statusQuery, values);
    const statusCounts = {};
    statusResult.rows.forEach(row => {
      statusCounts[row.status] = parseInt(row.count, 10);
    });

    // Get banker acceptance, sanction, disbursement counts from bank_assignments with filter
    const bankerStatsQuery = `
      SELECT 
        COUNT(DISTINCT c.caseid) FILTER (WHERE UPPER(ba.status) IN ('ACCEPT', 'ACCEPTED', 'IN-PROGRESS', 'IN_PROGRESS', 'APPROVED', 'SANCTIONED', 'DISBURSED')) as banker_accepted,
        COUNT(DISTINCT c.caseid) FILTER (WHERE UPPER(ba.status) IN ('SANCTIONED', 'DISBURSED')) as sanctioned,
        COUNT(DISTINCT c.caseid) FILTER (WHERE UPPER(ba.status) = 'DISBURSED') as disbursed
      FROM cases c
      LEFT JOIN bank_assignments ba ON c.caseid = ba.caseid
      ${whereClause}
    `;
    const bankerStatsResult = await pool.query(bankerStatsQuery, values);
    const bankerStats = bankerStatsResult.rows[0];

    // Calculate ratios
    const totalLeads = parseInt(statsRow.total_leads, 10) || 0;
    const meetingDone = parseInt(statsRow.meeting_done, 10) || 0;
    const documentationInitiated = parseInt(statsRow.documentation_initiated, 10) || 0;
    const bankerAccepted = parseInt(bankerStats.banker_accepted, 10) || 0;
    const sanctioned = parseInt(bankerStats.sanctioned, 10) || 0;
    const disbursed = parseInt(bankerStats.disbursed, 10) || 0;

    const ratios = {
      leadsToMeeting: totalLeads > 0 ? ((meetingDone / totalLeads) * 100).toFixed(1) : "0",
      meetingToDocuments: meetingDone > 0 ? ((documentationInitiated / meetingDone) * 100).toFixed(1) : "0",
      documentsToBankerAcceptance: documentationInitiated > 0 ? ((bankerAccepted / documentationInitiated) * 100).toFixed(1) : "0",
      bankerAcceptanceToSanction: bankerAccepted > 0 ? ((sanctioned / bankerAccepted) * 100).toFixed(1) : "0",
      sanctionToDisbursement: sanctioned > 0 ? ((disbursed / sanctioned) * 100).toFixed(1) : "0"
    };

    const ratioCounts = {
      leadsToMeeting: { num: meetingDone, den: totalLeads },
      meetingToDocuments: { num: documentationInitiated, den: meetingDone },
      documentsToBankerAcceptance: { num: bankerAccepted, den: documentationInitiated },
      bankerAcceptanceToSanction: { num: sanctioned, den: bankerAccepted },
      sanctionToDisbursement: { num: disbursed, den: sanctioned }
    };

    res.json({
      today: parseInt(statsRow.today_count, 10) || 0,
      last7Days: parseInt(statsRow.last_7_days_count, 10) || 0,
      last30Days: parseInt(statsRow.last_30_days_count, 10) || 0,
      thisFinancialYear: parseInt(statsRow.financial_year_count, 10) || 0,
      statusCounts,
      ratios,
      ratioCounts
    });
  } catch (err) {
    console.error("Get Dashboard Stats Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Get user-filtered dashboard statistics (counts, ratios) - optimized endpoint with filters
exports.getUserDashboardStats = async (req, res) => {
  try {
    const { userId, userIds, dateFilter, dateFrom, dateTo } = req.query;
    
    // Build date range conditions
    let dateCondition = "";
    const values = [];
    let paramIndex = 1;
    
    // Build WHERE clause parts
    const whereConditions = [];
    
    // User filter - support both single userId (legacy) and multiple userIds
    // Parse userIds as comma-separated string
    let userIdArray = [];
    if (userIds) {
      userIdArray = userIds.split(',').map(id => parseInt(id.trim(), 10)).filter(id => !isNaN(id));
    } else if (userId) {
      userIdArray = [parseInt(userId, 10)].filter(id => !isNaN(id));
    }
    
    if (userIdArray.length > 0) {
      if (userIdArray.length === 1) {
        whereConditions.push(`(
          EXISTS (SELECT 1 FROM case_assignments ca WHERE ca.caseid = c.caseid AND ca.assigned_to = $${paramIndex})
          OR c.createdby = $${paramIndex}
        )`);
        values.push(userIdArray[0]);
        paramIndex++;
      } else {
        // Multiple users - use ANY for arrays
        const placeholders = userIdArray.map((_, i) => `$${paramIndex + i}`);
        whereConditions.push(`(
          EXISTS (SELECT 1 FROM case_assignments ca WHERE ca.caseid = c.caseid AND ca.assigned_to IN (${placeholders.join(', ')}))
          OR c.createdby IN (${placeholders.join(', ')})
        )`);
        values.push(...userIdArray);
        paramIndex += userIdArray.length;
      }
    }
    
    // Date filter logic
    const now = new Date();
    let filterDateFrom = null;
    let filterDateTo = null;
    
    switch (dateFilter) {
      case 'today':
        filterDateFrom = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        filterDateTo = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59);
        break;
      case 'yesterday':
        const yesterday = new Date(now);
        yesterday.setDate(yesterday.getDate() - 1);
        filterDateFrom = new Date(yesterday.getFullYear(), yesterday.getMonth(), yesterday.getDate());
        filterDateTo = new Date(yesterday.getFullYear(), yesterday.getMonth(), yesterday.getDate(), 23, 59, 59);
        break;
      case 'last7days':
        filterDateFrom = new Date(now);
        filterDateFrom.setDate(filterDateFrom.getDate() - 7);
        filterDateTo = now;
        break;
      case 'last30days':
        filterDateFrom = new Date(now);
        filterDateFrom.setDate(filterDateFrom.getDate() - 30);
        filterDateTo = now;
        break;
      case 'thisweek':
        const dayOfWeek = now.getDay();
        const mondayOffset = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;
        filterDateFrom = new Date(now);
        filterDateFrom.setDate(filterDateFrom.getDate() + mondayOffset);
        filterDateFrom.setHours(0, 0, 0, 0);
        filterDateTo = new Date(filterDateFrom);
        filterDateTo.setDate(filterDateTo.getDate() + 6);
        filterDateTo.setHours(23, 59, 59, 999);
        break;
      case 'thismonth':
        filterDateFrom = new Date(now.getFullYear(), now.getMonth(), 1);
        filterDateTo = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59);
        break;
      case 'thisyear':
        filterDateFrom = new Date(now.getFullYear(), 0, 1);
        filterDateTo = new Date(now.getFullYear(), 11, 31, 23, 59, 59);
        break;
      case 'financialyear':
        filterDateFrom = now.getMonth() >= 3 
          ? new Date(now.getFullYear(), 3, 1)
          : new Date(now.getFullYear() - 1, 3, 1);
        filterDateTo = now.getMonth() >= 3 
          ? new Date(now.getFullYear() + 1, 2, 31, 23, 59, 59)
          : new Date(now.getFullYear(), 2, 31, 23, 59, 59);
        break;
      case 'lastfinancialyear':
        filterDateFrom = now.getMonth() >= 3 
          ? new Date(now.getFullYear() - 1, 3, 1)
          : new Date(now.getFullYear() - 2, 3, 1);
        filterDateTo = now.getMonth() >= 3 
          ? new Date(now.getFullYear(), 2, 31, 23, 59, 59)
          : new Date(now.getFullYear() - 1, 2, 31, 23, 59, 59);
        break;
      case 'custom':
        if (dateFrom) filterDateFrom = new Date(dateFrom);
        if (dateTo) filterDateTo = new Date(dateTo + 'T23:59:59');
        break;
      default:
        // 'all' - no date filter
        break;
    }
    
    if (filterDateFrom) {
      whereConditions.push(`c.createddate >= $${paramIndex}`);
      values.push(filterDateFrom);
      paramIndex++;
    }
    if (filterDateTo) {
      whereConditions.push(`c.createddate <= $${paramIndex}`);
      values.push(filterDateTo);
      paramIndex++;
    }
    
    const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';
    
    // Get current date info for time-based counts
    const todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const last7DaysStart = new Date(todayStart);
    last7DaysStart.setDate(last7DaysStart.getDate() - 7);
    const last30DaysStart = new Date(todayStart);
    last30DaysStart.setDate(last30DaysStart.getDate() - 30);
    
    // Financial year starts April 1st
    const financialYearStart = now.getMonth() >= 3
      ? new Date(now.getFullYear(), 3, 1)
      : new Date(now.getFullYear() - 1, 3, 1);

    // Single query to get all counts with filters
    const statsQuery = `
      SELECT 
        COUNT(*) FILTER (WHERE DATE(c.createddate) = CURRENT_DATE) as today_count,
        COUNT(*) FILTER (WHERE c.createddate >= $${paramIndex}) as last_7_days_count,
        COUNT(*) FILTER (WHERE c.createddate >= $${paramIndex + 1}) as last_30_days_count,
        COUNT(*) FILTER (WHERE c.createddate >= $${paramIndex + 2}) as financial_year_count,
        COUNT(*) as total_leads,
        COUNT(*) FILTER (WHERE LOWER(c.status) IN ('meeting done', 'documentation initiated', 'documentation in progress', 'underwriting', 'one pager', 'banker review', 'login', 'pd', 'sanctioned', 'disbursement', 'done')) as meeting_done,
        COUNT(*) FILTER (WHERE LOWER(c.status) IN ('documentation initiated', 'documentation in progress', 'underwriting', 'one pager', 'banker review', 'login', 'pd', 'sanctioned', 'disbursement', 'done')) as documentation_initiated
      FROM cases c
      ${whereClause}
    `;
    
    const statsValues = [...values, last7DaysStart, last30DaysStart, financialYearStart];
    const statsResult = await pool.query(statsQuery, statsValues);
    const statsRow = statsResult.rows[0];

    // Get status counts with filters
    const statusQuery = `
      SELECT c.status, COUNT(*) as count
      FROM cases c
      ${whereClause}
      GROUP BY c.status
    `;
    const statusResult = await pool.query(statusQuery, values);
    const statusCounts = {};
    statusResult.rows.forEach(row => {
      if (row.status) {
        statusCounts[row.status] = parseInt(row.count, 10);
      }
    });

    // Get banker acceptance, sanction, disbursement counts with filters
    const bankerStatsQuery = `
      SELECT 
        COUNT(DISTINCT c.caseid) FILTER (WHERE UPPER(ba.status) IN ('ACCEPT', 'ACCEPTED', 'IN-PROGRESS', 'IN_PROGRESS', 'APPROVED', 'SANCTIONED', 'DISBURSEMENT')) as banker_accepted,
        COUNT(DISTINCT c.caseid) FILTER (WHERE UPPER(ba.status) IN ('SANCTIONED', 'DISBURSEMENT')) as sanctioned,
        COUNT(DISTINCT c.caseid) FILTER (WHERE UPPER(ba.status) = 'DISBURSEMENT') as disbursed
      FROM cases c
      LEFT JOIN bank_assignments ba ON c.caseid = ba.caseid
      ${whereClause}
    `;
    const bankerStatsResult = await pool.query(bankerStatsQuery, values);
    const bankerStats = bankerStatsResult.rows[0];

    // Calculate ratios
    const totalLeads = parseInt(statsRow.total_leads, 10) || 0;
    const meetingDone = parseInt(statsRow.meeting_done, 10) || 0;
    const documentationInitiated = parseInt(statsRow.documentation_initiated, 10) || 0;
    const bankerAccepted = parseInt(bankerStats.banker_accepted, 10) || 0;
    const sanctioned = parseInt(bankerStats.sanctioned, 10) || 0;
    const disbursed = parseInt(bankerStats.disbursed, 10) || 0;

    const ratios = {
      leadsToMeeting: totalLeads > 0 ? ((meetingDone / totalLeads) * 100).toFixed(1) : "0",
      meetingToDocuments: meetingDone > 0 ? ((documentationInitiated / meetingDone) * 100).toFixed(1) : "0",
      documentsToBankerAcceptance: documentationInitiated > 0 ? ((bankerAccepted / documentationInitiated) * 100).toFixed(1) : "0",
      bankerAcceptanceToSanction: bankerAccepted > 0 ? ((sanctioned / bankerAccepted) * 100).toFixed(1) : "0",
      sanctionToDisbursement: sanctioned > 0 ? ((disbursed / sanctioned) * 100).toFixed(1) : "0"
    };

    const ratioCounts = {
      leadsToMeeting: { num: meetingDone, den: totalLeads },
      meetingToDocuments: { num: documentationInitiated, den: meetingDone },
      documentsToBankerAcceptance: { num: bankerAccepted, den: documentationInitiated },
      bankerAcceptanceToSanction: { num: sanctioned, den: bankerAccepted },
      sanctionToDisbursement: { num: disbursed, den: sanctioned }
    };

    res.json({
      today: parseInt(statsRow.today_count, 10) || 0,
      last7Days: parseInt(statsRow.last_7_days_count, 10) || 0,
      last30Days: parseInt(statsRow.last_30_days_count, 10) || 0,
      thisFinancialYear: parseInt(statsRow.financial_year_count, 10) || 0,
      statusCounts,
      ratios,
      ratioCounts,
      totalFiltered: totalLeads
    });
  } catch (err) {
    console.error("Get User Dashboard Stats Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Get cases with documents, comments, and KAM assignment
exports.getCases = async (req, res) => {
  const userId = req.user.id;
  const { role, page = 1, pageSize = 50, status: statusFilter } = req.query;
  const pageNum = parseInt(page, 10) || 1;
  const pageSizeNum = parseInt(pageSize, 10) || 50;
  const offset = (pageNum - 1) * pageSizeNum;
  
  // Simple in-memory cache for cases
  // Key: userId + page + pageSize + statusFilter
  if (!global.caseCache) global.caseCache = new Map();
  const cacheKey = `${req.user.id}_${req.query.page || 1}_${req.query.pageSize || 50}_${req.query.status || ''}`;
  if (global.caseCache.has(cacheKey)) {
    // Serve from cache
    return res.json(global.caseCache.get(cacheKey));
  }
  try {
    const userResult = await pool.query(
      `SELECT users.*, roles.rolename FROM users JOIN roles ON users.roleid = roles.id WHERE users.id = $1`,
      [userId]
    );
    const user = userResult.rows[0];

    let query = `
  SELECT 
    c.*, 
    u.name AS assigned_to_name, 
    u.email AS assigned_to_email, 
    u.phone, 
    ca.role AS assigned_to_role,
    kam_ca.assigned_to AS "assignedKam",
    ba.bankid,
    b.name AS bank_name,
    ba.status AS bank_assignment_status,
    ba.document_config
  FROM cases c
  LEFT JOIN case_assignments ca ON ca.caseid = c.caseid
  LEFT JOIN users u ON u.id = ca.assigned_to
  LEFT JOIN case_assignments kam_ca ON kam_ca.caseid = c.caseid AND kam_ca.role = 'KAM'
  LEFT JOIN bank_assignments ba ON ba.caseid = c.caseid
  LEFT JOIN banks b ON b.id = ba.bankid
`;
    let values = [];

    let result;
    if (user.rolename === "Admin") {
      if (role) {
        if (role == "uw") {
          query += `  WHERE LOWER(c.status) in  ('one pager', 'underwriting', 'rejected', 'disbursement','pd', 'sanctioned', 'done', 'accept', 'login') or ca.role = 'Banker' ORDER BY c.id DESC`;
          result = await pool.query(query, values);
        }
      } else {
        query += ` ORDER BY c.id DESC`;
        result = await pool.query(query, values);
      }

    } else if (user.rolename === "Individual") {
      query += ` WHERE c.role = 'Individual' AND LOWER(c.spocemail) = LOWER($1) ORDER BY c.id DESC`;
      values.push(user.email);
      result = await pool.query(query, values);
    } else if (user.rolename === "Banker") {
      query += ` WHERE ca.role = 'Banker' and b.email = $1 ORDER BY c.id DESC`;
      values.push(user.email);
      result = await pool.query(query, values);
    } else if (user.rolename === "UW") {
      query += ` WHERE LOWER(c.status) in  ('one pager', 'underwriting', 'rejected', 'disbursement','pd', 'sanctioned', 'done', 'accept', 'login') or ca.role = 'Banker' ORDER BY c.id DESC`;
      result = await pool.query(query, values);
    } else if (
      user.rolename === "Operations"
    ) {
      query += ` WHERE LOWER(c.status) IN (
        'open', 
        'meeting done', 
        'documentation initiated', 
        'documentation in progress', 
        'underwriting', 
        'one pager',
        'banker review',
        'no requirement',
        'accept',
        'login',
        'pd',
        'sanctioned',
        'disbursement',
        'done',
        'rejected'
      ) ORDER BY c.id DESC`;
      result = await pool.query(query, values);
    } else if (user.rolename === "KAM") {
      query += ` WHERE kam_ca.assigned_to = $1 ORDER BY c.id DESC`;
      values.push(userId);
      result = await pool.query(query, values);
    } else if (user.rolename === "Telecaller") {
      query += ` WHERE c.createdby = $1 ORDER BY c.id DESC`;
      values.push(userId);
      result = await pool.query(query, values);
    } else {
      query += ` WHERE ca.assigned_to = $1 ORDER BY c.id DESC`;
      values.push(userId);
      result = await pool.query(query, values);
    }

    // Group by caseid and aggregate assignments
    const caseMap = new Map();
    for (const row of result.rows) {
      if (!caseMap.has(row.caseid)) {
        // Initialize case object with assignments array
        caseMap.set(row.caseid, {
          ...row,
          assignments: [],
          bank_assignments: []
        });
      }
      // Add assignment info to assignments array
      caseMap.get(row.caseid).assignments.push({
        assigned_to_name: row.assigned_to_name,
        assigned_to_email: row.assigned_to_email,
        phone: row.phone,
        assigned_to_role: row.assigned_to_role,
      });

      if (row.bankid) {
        const bankAssignments = caseMap.get(row.caseid).bank_assignments;
        // Only push if this bankid is not already in the array
        if (!bankAssignments.some(ba => ba.bankid === row.bankid)) {
          bankAssignments.push({
            bankid: row.bankid,
            bank_name: row.bank_name,
            status: row.bank_assignment_status,
            document_config: row.document_config
          });
        }
      }
    }
    const cases = Array.from(caseMap.values());
    const caseIds = cases.map(c => c.caseid);

    // Batch fetch all related data to avoid N+1 queries
    const [allDocs, allComments, allBanks, productReqs] = await Promise.all([
      pool.query(`SELECT * FROM documents WHERE caseid = ANY($1) ORDER BY uploadedat DESC`, [caseIds]),
      pool.query(`SELECT * FROM comments WHERE caseid = ANY($1) ORDER BY created_at DESC`, [caseIds]),
      pool.query(`SELECT * FROM banks`),
      // Gracefully handle if table doesn't exist
      pool.query(`SELECT * FROM case_product_requirements WHERE caseid = ANY($1) ORDER BY id`, [caseIds]).catch(() => ({ rows: [] }))
    ]);

    // Create lookup maps for O(1) access
    const docsMap = new Map();
    allDocs.rows.forEach(doc => {
      if (!docsMap.has(doc.caseid)) docsMap.set(doc.caseid, []);
      docsMap.get(doc.caseid).push(doc);
    });

    const commentsMap = new Map();
    allComments.rows.forEach(comment => {
      if (!commentsMap.has(comment.caseid)) commentsMap.set(comment.caseid, []);
      commentsMap.get(comment.caseid).push(comment);
    });

    const banksMap = new Map();
    allBanks.rows.forEach(bank => banksMap.set(bank.name, bank));

    const productReqsMap = new Map();
    productReqs.rows.forEach(pr => {
      if (!productReqsMap.has(pr.caseid)) productReqsMap.set(pr.caseid, []);
      productReqsMap.get(pr.caseid).push(pr);
    });

    // Get bank ID for banker role (only one query needed)
    let bankId = null;
    if (user.rolename === "Banker") {
      const bankRes = await pool.query(`SELECT id FROM banks WHERE email = $1 LIMIT 1`, [user.email]);
      bankId = bankRes.rows[0]?.id;
    }

    for (const c of cases) {
      c.hasSpocAdmin = false; // Skip this check for performance, or batch it if needed
      c.product_requirements = productReqsMap.get(c.caseid) || [];

      const allDocsForCase = docsMap.get(c.caseid) || [];
      const latestOnePager = allDocsForCase.find(d => d.doctype === "onePager");
      const filteredDocs = [
        ...allDocsForCase.filter(d => d.doctype !== "onePager"),
        ...(latestOnePager ? [latestOnePager] : [])
      ];
      c.documents = filteredDocs;

      //if role is banker, filter only the documents required by that bank from bank_assignments
      if (user.rolename === "Banker") {
        const bankAssignments = c.bank_assignments || [];
        const bankAssignment = bankAssignments.find(ba => ba.bankid === bankId);

        if (bankAssignment && bankAssignment.document_config) {
          const allowedDocs = Object.entries(bankAssignment.document_config)
            .filter(([_, value]) => value === true)
            .map(([key]) => key);

          c.documents = allDocsForCase.filter(doc =>
            allowedDocs.includes(`${doc.doctype}_${doc.docname}`)
          );
        } else {
          c.documents = [];
        }
        c.bank_assignment_status = bankAssignment ? bankAssignment.status : null;
      }

      c.comments = commentsMap.get(c.caseid) || [];
      c.bankDetails = banksMap.get(c.bankname) || null;
      c.clientCredentials = null; // Skip for performance
    }

    // If case is assigned to a banker then keep that status as Banker Review and status is not rejected or disbursement or sanctioned or Done
    for (const c of cases) {
      if (c.assigned_to_role === "Banker" && !["rejected", "disbursement", "sanctioned", "Done"].includes(c.status?.toLowerCase())) {
        c.status = "Banker Review";
      }
    }

    // Bank assignments status order is "REJECT", "OPEN", "ACCEPT", "LOGIN", "PD", "SANCTIONED", "DISBURSEMENT", "DONE"
    // If role is Operations or Admin and if Stage is One Pager then check the Bank Assignment status for each bank and based on  status order any bank has moved the case to next stage then update the case status to that status

    const statusOrder = ["REJECT", "OPEN", "LOGIN", "PD", "SANCTIONED", "DISBURSEMENT", "DONE"];
    for (const c of cases) {
      if (["Operations", "Admin"].includes(user.rolename) && c.status.toLowerCase() === "banker review") {
        let highestStatusIndex = -1;
        for (const ba of c.bank_assignments) {
          const index = statusOrder.indexOf(ba.status);
          if (index > highestStatusIndex) {
            highestStatusIndex = index;
          }
        }
        if (highestStatusIndex !== -1) {
          c.status = statusOrder[highestStatusIndex];
        }
      }
    }

    // Return total count for pagination support
    res.json({ cases, totalCount: cases.length, page: pageNum, pageSize: pageSizeNum });
    // Store in cache
    global.caseCache.set(cacheKey, { cases, totalCount: cases.length, page: pageNum, pageSize: pageSizeNum });
  } catch (err) {
    console.error("Get Cases Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Update case with case ID
exports.updateCase = async (req, res) => {
  const { caseid } = req.params;
  const {
    companyname,
    clientname,
    phonenumber,
    leadsource,
    turnover,
    location,
    spocemail,
    spocname,
    spocphonenumber,
    date,
    time,
    status,
    role,
    comments,
    kamAssignee,
    bankname,
    stage
  } = req.body;

  try {
    // Get current status before update for logging
    const currentCaseResult = await pool.query(
      `SELECT status FROM cases WHERE caseid = $1`,
      [caseid]
    );
    const oldStatus = currentCaseResult.rows[0]?.status;

    // 1. Update the case details
    await pool.query(
      `UPDATE cases
       SET companyname = $1,
           clientname = $2,
           phonenumber = $3,
           leadsource = $4,
           turnover = $5,
           location = $6,
           spocemail = $7,
           spocname = $8,
           spocphonenumber = $9,
           date = $10,
           time = $11,
           status = $12,
           role = $13,
           bankname = $14,
           stage = $15,
           updatedat = NOW()
       WHERE caseid = $16`,
      [
        companyname,
        clientname,
        phonenumber,
        leadsource,
        turnover,
        location,
        spocemail,
        spocname,
        spocphonenumber,
        date,
        time,
        status,
        role,
        bankname,
        stage,
        caseid
      ]
    );

    // 2. Assign KAM (conditionally update or insert)
    if (kamAssignee) {
      const existingAssignment = await pool.query(
        `SELECT * FROM case_assignments WHERE caseid = $1 AND role = $2`,
        [caseid, "KAM"]
      );

      if (existingAssignment.rows.length > 0) {
        // update existing assignment
        await pool.query(
          `UPDATE case_assignments
           SET assigned_to = $1,
               assigned_date = NOW()
           WHERE caseid = $2 AND role = $3`,
          [kamAssignee, caseid, "KAM"]
        );
      } else {
        // insert new assignment
        await pool.query(
          `INSERT INTO case_assignments (caseid, assigned_to, role, assigned_date)
           VALUES ($1, $2, $3, NOW())`,
          [caseid, kamAssignee, "KAM"]
        );
      }
    }

    // 3. Add comment if provided
    if (typeof comments === "string" && comments.trim()) {
      const userInfo = await pool.query("SELECT name, email FROM users WHERE id = $1", [req.user.id]);
      const user = userInfo.rows[0];
      const commentby = user?.name || user?.email || "User";

      await pool.query(
        `INSERT INTO comments (caseid, comment, role, created_at, commentby)
     VALUES ($1, $2, $3, NOW(), $4)`,
        [caseid, comments.trim(), req.user.rolename || "Unknown", commentby]
      );
    }

    // 4. Log status change if status was updated
    if (status && oldStatus !== status) {
      await logStatusChange(caseid, oldStatus, status, req.user.id, "Status updated via case edit");
    }

    // Invalidate cache for this user's cases (all pages)
    if (global.caseCache) {
      const userId = req.user.id;
      for (const key of global.caseCache.keys()) {
        if (key.startsWith(`${userId}_`)) {
          global.caseCache.delete(key);
        }
      }
    }
    res.json({ message: "Case updated successfully" });
  } catch (err) {
    console.error("Update Case Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// PATCH: Update only the status field of a case (Banker use)
exports.updateCaseStatus = async (req, res) => {
  const { caseid } = req.params;
  const { status, products, description } = req.body;


  try {
    if (!status) return res.status(400).json({ error: "Missing status field" });

    // Get current status before update for logging
    const currentCaseResult = await pool.query(
      `SELECT status FROM cases WHERE caseid = $1`,
      [caseid]
    );
    const oldStatus = currentCaseResult.rows[0]?.status;

    // Update both status and stage to keep them in sync
    await pool.query(
      `UPDATE cases SET status = $1, stage = $1, updatedat = NOW(), status_updated_on = NOW() WHERE caseid = $2`,
      [status, caseid]
    );

    //if status is Meeting Done then set meeting_done_date to current date
    if (status === "Meeting Done") {
      await pool.query(
        `UPDATE cases SET meeting_done_date = NOW() WHERE caseid = $1`,
        [caseid]
      );
    }

    // Handle multiple products with description
    if (products && Array.isArray(products) && products.length > 0) {
      // Delete existing product requirements for this case
      await pool.query(
        `DELETE FROM case_product_requirements WHERE caseid = $1`,
        [caseid]
      );

      // Insert new product requirements (ensure amount is stored as string)
      for (const prod of products) {
        const amountStr = String(prod.amount);
        await pool.query(
          `INSERT INTO case_product_requirements (caseid, productname, requirement_amount, description, created_at)
           VALUES ($1, $2, $3, $4, NOW())`,
          [caseid, prod.product, amountStr, description || null]
        );
      }

      // Also update the main case table with the first product for backward compatibility
      await pool.query(
        `UPDATE cases SET productname = $1, requirement_amount = $2 WHERE caseid = $3`,
        [products[0].product, String(products[0].amount), caseid]
      );
    }

    // Log status change
    if (oldStatus !== status) {
      await logStatusChange(caseid, oldStatus, status, req.user?.id, null);
    }

    // Invalidate cache for all users since case status is updated
    if (global.caseCache) {
      global.caseCache.clear();
    }

    return res.json({ message: `Status updated to '${status}' for case ${caseid}` });
  } catch (err) {
    console.error("Update Case Status Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.updateBankStatus = async (req, res) => {
  const { caseid } = req.params;
  const { status } = req.body;
  const userId = req.user.id;
  try {
    if (!status) return res.status(400).json({ error: "Missing status field" });

    //need to get bank id based on logged in user's email and bank email

    const userResult = await pool.query(
      `SELECT users.*, roles.rolename FROM users JOIN roles ON users.roleid = roles.id WHERE users.id = $1`,
      [userId]
    );
    const user = userResult.rows[0];
    const bankEmail = user.email;
    if (!bankEmail) return res.status(400).json({ error: "Missing bankEmail field" });

    const bankRes = await pool.query(
      `SELECT id FROM banks WHERE email = $1 LIMIT 1`,
      [bankEmail]
    );
    const bankId = bankRes.rows[0]?.id;
    if (!bankId) return res.status(400).json({ error: "Invalid bank email" });

    await pool.query(
      `UPDATE bank_assignments SET status = $1, updatedat = NOW() WHERE caseid = $2 AND bankid = $3`,
      [status, caseid, bankId]
    );

    // Invalidate cache for all users since bank status is updated
    if (global.caseCache) {
      global.caseCache.clear();
    }

    return res.json({ message: `Status updated to '${status}' for case ${caseid}` });
  } catch (err) {
    console.error("Update Case Status Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// POST: Get cases by role (e.g., for /cases/by-role)
exports.getCasesByRole = async (req, res) => {
  const { role, email } = req.body;

  try {
    if (!role) return res.status(400).json({ error: "Missing role field" });

    const result = await pool.query(
      `SELECT * FROM cases WHERE cases.spocemail = $1 ORDER BY id DESC`,
      [email]
    );

    const cases = await Promise.all(
      result.rows.map(async (c) => {
        const docs = await pool.query(`SELECT * FROM documents WHERE caseid = $1`, [c.caseid]);
        const comments = await pool.query(`SELECT * FROM comments WHERE caseid = $1 ORDER BY created_at DESC`, [c.caseid]);
        c.documents = docs.rows;
        c.comments = comments.rows;
        return c;
      })
    );

    //Here need to check if provisional documents exist for each case too and add them to documents array, if already existed in docs then no need to add that provisional document again
    for (const c of cases) {
      const provDocs = await pool.query(`SELECT * FROM provisional_documents WHERE caseid = $1 ORDER BY id`, [c.caseid]);
      console.log("Prov Docs:", provDocs.rows);
      //here need to check provisional document name with existing document names in c.documents and only add those which are not already present
      const existingDocNames = c.documents.map(doc => doc.docname);
      console.log("Existing Doc Names:", existingDocNames);
      const newProvDocs = provDocs.rows.filter(provDoc => !existingDocNames.includes(provDoc.document_name));
      c.provisional_docs = newProvDocs;
    }

    return res.json({ cases });
  } catch (err) {
    console.error("Get Cases by Role Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// GET: et cases by caseid
exports.getCaseById = async (req, res) => {
  try {
    const caseid = req.params.caseid;

    // Fetch case with assignments and bank assignments (similar to getCases)
    const result = await pool.query(`
      SELECT 
        c.*, 
        u.name AS assigned_to_name, 
        u.email AS assigned_to_email, 
        u.phone, 
        ca.role AS assigned_to_role,
        kam_ca.assigned_to AS "assignedKam",
        ba.bankid,
        b.name AS bank_name,
        ba.status AS bank_assignment_status,
        ba.document_config
      FROM cases c
      LEFT JOIN case_assignments ca ON ca.caseid = c.caseid
      LEFT JOIN users u ON u.id = ca.assigned_to
      LEFT JOIN case_assignments kam_ca ON kam_ca.caseid = c.caseid AND kam_ca.role = 'KAM'
      LEFT JOIN bank_assignments ba ON ba.caseid = c.caseid
      LEFT JOIN banks b ON b.id = ba.bankid
      WHERE c.caseid = $1
    `, [caseid]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Case not found" });
    }

    // Group assignments and bank_assignments
    const caseData = { ...result.rows[0], assignments: [], bank_assignments: [] };
    for (const row of result.rows) {
      // Add assignment info to assignments array (avoid duplicates)
      if (row.assigned_to_name && !caseData.assignments.some(a => a.assigned_to_name === row.assigned_to_name && a.assigned_to_role === row.assigned_to_role)) {
        caseData.assignments.push({
          assigned_to_name: row.assigned_to_name,
          assigned_to_email: row.assigned_to_email,
          phone: row.phone,
          assigned_to_role: row.assigned_to_role,
        });
      }
      // Add bank assignment (avoid duplicates)
      if (row.bankid && !caseData.bank_assignments.some(ba => ba.bankid === row.bankid)) {
        caseData.bank_assignments.push({
          bankid: row.bankid,
          bank_name: row.bank_name,
          status: row.bank_assignment_status,
          document_config: row.document_config
        });
      }
    }

    // Fetch documents, comments, product_requirements, and bank details in parallel
    const [docsRes, commentsRes, productReqsRes, bankRes] = await Promise.all([
      pool.query(`SELECT * FROM documents WHERE caseid = $1 ORDER BY uploadedat DESC`, [caseid]),
      pool.query(`SELECT * FROM comments WHERE caseid = $1 ORDER BY created_at DESC`, [caseid]),
      pool.query(`SELECT * FROM case_product_requirements WHERE caseid = $1 ORDER BY id`, [caseid]),
      caseData.bankname ? pool.query(`SELECT * FROM banks WHERE name = $1 LIMIT 1`, [caseData.bankname]) : Promise.resolve({ rows: [] })
    ]);

    caseData.documents = docsRes.rows;
    caseData.comments = commentsRes.rows;
    caseData.product_requirements = productReqsRes.rows;
    caseData.bankDetails = bankRes.rows[0] || null;
    caseData.hasSpocAdmin = false;
    caseData.clientCredentials = null;

    res.json({ case: caseData });
  } catch (err) {
    console.error("Get case error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

// Edit Case
exports.editCase = async (req, res) => {
  const { caseid } = req.params;
  const {
    companyname,
    clientname,
    phonenumber,
    leadsource,
    turnover,
    location,
    spocemail,
    spocname,
    spocphonenumber,
    date,
    time,
    status,
    role,
    comments,
    kamAssignee,
    bankname,
    stage
  } = req.body;

  try {
    await pool.query(
      `UPDATE cases
       SET companyname = $1,
           clientname = $2,
           phonenumber = $3,
           leadsource = $4,
           turnover = $5,
           location = $6,
           spocemail = $7,
           spocname = $8,
           spocphonenumber = $9,
           date = $10,
           time = $11,
           role = $12,
           bankname = $13,
           updatedat = NOW()
       WHERE caseid = $14`,
      [
        companyname,
        clientname,
        phonenumber,
        leadsource,
        turnover,
        location,
        spocemail,
        spocname,
        spocphonenumber,
        date,
        time,
        role || "Telecaller",
        bankname,
        caseid
      ]
    );

    if (kamAssignee) {
      await pool.query(
        `INSERT INTO case_assignments (caseid, assigned_to, role, assigned_date)
         VALUES ($1, $2, 'KAM', NOW())
         ON CONFLICT (caseid, role) DO UPDATE
         SET assigned_to = EXCLUDED.assigned_to,
             assigned_date = NOW()`,
        [caseid, kamAssignee]
      );
    }

    if (typeof comments === "string" && comments.trim()) {
      const userInfo = await pool.query("SELECT name, email FROM users WHERE id = $1", [req.user.id]);
      const user = userInfo.rows[0];
      const commentby = user?.name || user?.email || "User";

      await pool.query(
        `INSERT INTO comments (caseid, comment, role, created_at, commentby)
     VALUES ($1, $2, $3, NOW(), $4)`,
        [caseid, comments.trim(), req.user.rolename || "Unknown", commentby]
      );
    }

    // Invalidate cache for all users since case is edited
    if (global.caseCache) {
      global.caseCache.clear();
    }

    res.json({ message: "Case updated successfully" });
  } catch (err) {
    console.error("Edit Case Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.generateClient = async (req, res) => {
  const { caseid } = req.params;

  try {
    // Fetch case details
    const caseResult = await pool.query(`SELECT * FROM cases WHERE caseid = $1`, [caseid]);
    const caseData = caseResult.rows[0];

    if (!caseData) {
      return res.status(404).json({ message: "Case not found" });
    }

    // with caseData spocemail and spocphonenumber we should create a user (role id is 1) with default password Rwot#321
    const existingUser = await pool.query(`SELECT * FROM users WHERE email = $1`, [caseData.spocemail]);
    if (existingUser.rowCount === 0) {
      // Create new user
      const newUser = await pool.query(
        `INSERT INTO users (name, email, phone, roleid, password, company)
         VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
        [caseData.spocname, caseData.spocemail, caseData.spocphonenumber, 1, "Rwot#321", caseData.companyname]
      );
      const clientData = newUser.rows[0];
      return res.json({ message: "Client generated successfully", clientData });
    }

    res.json({ message: "Client generated successfully", clientData: existingUser.rows[0] });
  } catch (err) {
    console.error("Generate Client Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};


// Save or update document configurations for multiple banks at once
// Expects: req.body = [{ bankid, documentConfig }, ...]
exports.saveDocumentConfigs = async (req, res) => {
  const { caseid } = req.params;
  const configs = req.body; // array of { bankerId, documents }

  try {
    if (!Array.isArray(configs) || configs.length === 0) {
      return res.status(400).json({ error: "Invalid configs format" });
    }

    // Delete existing bank_assignments for this caseid before inserting new ones
    await pool.query(
      `DELETE FROM bank_assignments WHERE caseid = $1`,
      [caseid]
    );

    await pool.query(
      `DELETE FROM case_assignments WHERE caseid = $1`,
      [caseid]
    );

    for (const cfg of configs) {
      if (!cfg.bankerId || typeof cfg.documents !== "object" || Object.keys(cfg.documents).length === 0) {
        continue; // skip invalid config
      }
      await pool.query(
        `INSERT INTO bank_assignments (caseid, bankid, document_config, createdat, updatedat)
         VALUES ($1, $2, $3, NOW(), NOW())
         ON CONFLICT (caseid, bankid) DO UPDATE
         SET document_config = EXCLUDED.document_config,
             updatedat = NOW()`,
        [caseid, cfg.bankerId, JSON.stringify(cfg.documents)]
      );

      await pool.query(
        `INSERT INTO case_assignments (caseid, assigned_to, role, assigned_date)
   VALUES (
     $1,
     (SELECT id FROM users WHERE email = (SELECT email FROM banks WHERE id = $2)),
     'Banker',
     NOW()
   )
   ON CONFLICT (caseid, role) DO UPDATE
   SET assigned_to = EXCLUDED.assigned_to,
       assigned_date = NOW()`,
        [caseid, cfg.bankerId]
      );
    }

    // Invalidate cache for all users since document configs are updated
    if (global.caseCache) {
      global.caseCache.clear();
    }

    res.json({ message: "Document configurations saved/updated successfully" });
  } catch (err) {
    console.error("Save Document Configs Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Get all document configurations for a case
exports.getDocumentConfigs = async (req, res) => {
  const { caseid } = req.params;

  try {
    const result = await pool.query(
      `SELECT * FROM bank_assignments WHERE caseid = $1`,
      [caseid]
    );
    res.json({ configs: result.rows });
  } catch (err) {
    console.error("Get Document Configs Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Delete document configuration for a case and bank
exports.deleteDocumentConfig = async (req, res) => {
  const { caseid } = req.params;
  const { bankid } = req.body;

  try {
    if (!bankid) return res.status(400).json({ error: "Missing bankid" });

    const result = await pool.query(
      `DELETE FROM bank_assignments WHERE caseid = $1 AND bankid = $2 RETURNING *`,
      [caseid, bankid]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "No document configuration found to delete" });
    }

    // Invalidate cache for all users since document config is deleted
    if (global.caseCache) {
      global.caseCache.clear();
    }

    res.json({ message: "Document configuration deleted successfully" });
  } catch (err) {
    console.error("Delete Document Config Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Get provisional documents based on caseid
exports.getProvisionalDocumentsByCase = async (req, res) => {
  const { caseid } = req.params;
  const userId = req.user.id;
  const userRole = req.user.rolename;

  try {
    let result

    result = await pool.query(
      `SELECT * FROM provisional_documents WHERE caseid = $1 AND requested_by = $2 ORDER BY id`,
      [caseid, userId]
    );


    res.json({ documents: result.rows });
  } catch (err) {
    console.error("Get Provisional Documents By Case Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.getAllProvisionalDocumentsByCase = async (req, res) => {
  const { caseid } = req.params;

  try {
    let result

    result = await pool.query(
      `SELECT * FROM provisional_documents WHERE caseid = $1 ORDER BY id`,
      [caseid]
    );


    res.json({ documents: result.rows });
  } catch (err) {
    console.error("Get Provisional Documents By Case Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Add a new provisional document for a case
exports.addProvisionalDocument = async (req, res) => {
  const { caseid } = req.params;
  const { document_name } = req.body;
  const userId = req.user.id;
  const userRole = req.user.rolename;

  try {
    if (!document_name) {
      return res.status(400).json({ error: "Missing document_name" });
    }

    const result = await pool.query(
      `INSERT INTO provisional_documents (caseid, document_name, requested_by, created_at)
       VALUES ($1, $2, $3, NOW())
       RETURNING *`,
      [caseid, document_name, userId]
    );

    // Invalidate cache for all users since provisional document is added
    if (global.caseCache) {
      global.caseCache.clear();
    }

    res.status(201).json({ message: "Provisional document added", document: result.rows[0] });
  } catch (err) {
    console.error("Add Provisional Document Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

//delete provisional document by id
exports.deleteProvisionalDocument = async (req, res) => {
  const { id } = req.params;

  try {
    const result = await pool.query(
      `DELETE FROM provisional_documents WHERE id = $1 RETURNING *`,
      [id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "Provisional document not found" });
    }

    // Invalidate cache for all users since provisional document is deleted
    if (global.caseCache) {
      global.caseCache.clear();
    }

    res.json({ message: "Provisional document deleted successfully" });
  } catch (err) {
    console.error("Delete Provisional Document Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ============================================================
// LIGHTWEIGHT LIST API FOR PERFORMANCE OPTIMIZATION
// ============================================================

/**
 * Get cases list with minimal data for cards
 * Supports: pagination, status filtering, role-based access
 * Query params: page, limit, status, search
 */
exports.getCasesList = async (req, res) => {
  const userId = req.user.id;
  const { 
    page = 1, 
    limit = 20, 
    status: statusFilter, 
    search,
    dateFrom,
    dateTo,
    cold
  } = req.query;
  
  const pageNum = parseInt(page, 10) || 1;
  const limitNum = parseInt(limit, 10) || 20;
  const offset = (pageNum - 1) * limitNum;

  try {
    // Get cold case threshold from app_settings
    const coldThresholdHours = await getColdCaseThreshold();
    
    // Get user role
    const userResult = await pool.query(
      `SELECT users.*, roles.rolename FROM users JOIN roles ON users.roleid = roles.id WHERE users.id = $1`,
      [userId]
    );
    const user = userResult.rows[0];
    if (!user) {
      return res.status(401).json({ error: "User not found" });
    }

    let whereConditions = [];
    let values = [];
    let paramIndex = 1;
    
    // Cold case exclusion statuses
    const coldExcludedStatuses = ['open', 'no requirement', 'done', 'rejected', 'meeting done'];
    
    // Determine if this is a cold case request
    const isColdRequest = cold === 'true' || statusFilter?.toLowerCase() === 'cold';

    // Role-based filtering
    if (user.rolename === "Telecaller") {
      whereConditions.push(`c.createdby = $${paramIndex}`);
      values.push(userId);
      paramIndex++;
    } else if (user.rolename === "KAM") {
      whereConditions.push(`EXISTS (SELECT 1 FROM case_assignments ca WHERE ca.caseid = c.caseid AND ca.role = 'KAM' AND ca.assigned_to = $${paramIndex})`);
      values.push(userId);
      paramIndex++;
    } else if (user.rolename === "Banker") {
      whereConditions.push(`EXISTS (SELECT 1 FROM case_assignments ca WHERE ca.caseid = c.caseid AND ca.role = 'Banker' AND ca.assigned_to = $${paramIndex})`);
      values.push(userId);
      paramIndex++;
    } else if (user.rolename === "Individual") {
      whereConditions.push(`c.role = 'Individual' AND LOWER(c.spocemail) = LOWER($${paramIndex})`);
      values.push(user.email);
      paramIndex++;
    } else if (user.rolename === "Operations") {
      whereConditions.push(`LOWER(c.status) IN (
        'open', 'meeting done', 'documentation initiated', 'documentation in progress', 
        'underwriting', 'one pager', 'banker review', 'no requirement',
        'accept', 'login', 'pd', 'sanctioned', 'disbursement', 'done', 'rejected'
      )`);
    }
    // Admin and UW see all cases

    // Status filter - supports comma-separated statuses
    if (statusFilter && statusFilter.toLowerCase() !== 'cold') {
      const statuses = statusFilter.split(',').map(s => s.trim()).filter(Boolean);
      if (statuses.length === 1) {
        whereConditions.push(`LOWER(c.status) = LOWER($${paramIndex})`);
        values.push(statuses[0]);
        paramIndex++;
      } else if (statuses.length > 1) {
        const placeholders = statuses.map((_, i) => `LOWER($${paramIndex + i})`);
        whereConditions.push(`LOWER(c.status) IN (${placeholders.join(', ')})`);
        values.push(...statuses);
        paramIndex += statuses.length;
      }
      
      // IMPORTANT: Exclude cold cases from regular status tabs
      // A case is cold if: status is not in excluded list AND status_updated_on < threshold hours ago
      const coldExclusionPlaceholders = coldExcludedStatuses.map((_, i) => `$${paramIndex + i}`).join(', ');
      whereConditions.push(`NOT (
        LOWER(c.status) NOT IN (${coldExclusionPlaceholders})
        AND c.status_updated_on IS NOT NULL 
        AND c.status_updated_on < NOW() - INTERVAL '${coldThresholdHours} hours'
      )`);
      values.push(...coldExcludedStatuses);
      paramIndex += coldExcludedStatuses.length;
    }

    // Cold case filter - cases inactive for more than threshold hours
    if (isColdRequest) {
      const coldPlaceholders = coldExcludedStatuses.map((_, i) => `$${paramIndex + i}`).join(', ');
      whereConditions.push(`LOWER(c.status) NOT IN (${coldPlaceholders})`);
      values.push(...coldExcludedStatuses);
      paramIndex += coldExcludedStatuses.length;
      whereConditions.push(`c.status_updated_on IS NOT NULL`);
      whereConditions.push(`c.status_updated_on < NOW() - INTERVAL '${coldThresholdHours} hours'`);
    }

    // Search filter (company name or client name)
    if (search && search.trim()) {
      whereConditions.push(`(
        LOWER(c.companyname) LIKE LOWER($${paramIndex}) OR 
        LOWER(c.clientname) LIKE LOWER($${paramIndex})
      )`);
      values.push(`%${search.trim()}%`);
      paramIndex++;
    }

    // Date range filter - use status_change_log for stage-specific date filtering
    // When status filter is applied, filter by when the case entered that status
    const hasStatusFilter = statusFilter && statusFilter.toLowerCase() !== 'cold';
    
    if (dateFrom || dateTo) {
      if (hasStatusFilter) {
        // Filter by when the case entered the selected status(es)
        const statuses = statusFilter.split(',').map(s => s.trim()).filter(Boolean);
        const statusPlaceholders = statuses.map((_, i) => `$${paramIndex + i}`);
        
        let statusDateCondition = `EXISTS (
          SELECT 1 FROM status_change_log scl 
          WHERE scl.caseid = c.caseid 
          AND LOWER(scl.new_status) IN (${statusPlaceholders.map(p => `LOWER(${p})`).join(', ')})`;
        
        values.push(...statuses);
        paramIndex += statuses.length;
        
        if (dateFrom) {
          statusDateCondition += ` AND scl.changed_at >= $${paramIndex}`;
          values.push(dateFrom);
          paramIndex++;
        }
        if (dateTo) {
          statusDateCondition += ` AND scl.changed_at <= $${paramIndex}::date + INTERVAL '1 day'`;
          values.push(dateTo);
          paramIndex++;
        }
        
        statusDateCondition += `)`;
        whereConditions.push(statusDateCondition);
      } else {
        // No status filter - use creation date as before
        if (dateFrom) {
          whereConditions.push(`c.createddate >= $${paramIndex}`);
          values.push(dateFrom);
          paramIndex++;
        }
        if (dateTo) {
          whereConditions.push(`c.createddate <= $${paramIndex}::date + INTERVAL '1 day'`);
          values.push(dateTo);
          paramIndex++;
        }
      }
    }

    const whereClause = whereConditions.length > 0 
      ? `WHERE ${whereConditions.join(' AND ')}` 
      : '';

    // Count query for pagination
    const countQuery = `
      SELECT COUNT(DISTINCT c.caseid) as total
      FROM cases c
      ${whereClause}
    `;
    const countResult = await pool.query(countQuery, values);
    const total = parseInt(countResult.rows[0]?.total || 0, 10);

    // Lightweight data query - only essential fields for cards
    const dataQuery = `
      SELECT
        c.id,
        c.caseid,
        c.companyname,
        c.clientname,
        c.status,
        c.status_updated_on,
        c.meeting_done_date,
        c.createddate,
        c.updatedat,
        c.phonenumber,
        c.spocemail,
        c.spocphonenumber,
        c.turnover,
        c.location,
        MAX(kam.name) AS kam_name,
        MAX(telecaller.name) AS telecaller_name,
        (SELECT COUNT(*) FROM bank_assignments ba WHERE ba.caseid = c.caseid) AS bank_count,
        (SELECT COUNT(*) FROM comments cm WHERE cm.caseid = c.caseid) AS comment_count,
        (
          SELECT json_agg(json_build_object('bankid', ba.bankid, 'bank_name', b.name, 'status', ba.status))
          FROM bank_assignments ba
          JOIN banks b ON b.id = ba.bankid
          WHERE ba.caseid = c.caseid
        ) AS bank_assignments,
        (
          SELECT json_agg(json_build_object('id', d.id, 'doctype', d.doctype, 'docname', d.docname, 'filename', d.filename, 'uploadedat', d.uploadedat))
          FROM documents d
          WHERE d.caseid = c.caseid
        ) AS documents
      FROM cases c
      LEFT JOIN case_assignments kam_ca ON kam_ca.caseid = c.caseid AND kam_ca.role = 'KAM'
      LEFT JOIN users kam ON kam.id = kam_ca.assigned_to
      LEFT JOIN case_assignments tc_ca ON tc_ca.caseid = c.caseid AND tc_ca.role = 'Telecaller'
      LEFT JOIN users telecaller ON telecaller.id = tc_ca.assigned_to
      ${whereClause}
      GROUP BY c.id, c.caseid, c.companyname, c.clientname, c.status, c.status_updated_on, 
               c.meeting_done_date, c.createddate, c.updatedat, c.phonenumber, c.spocemail, 
               c.spocphonenumber, c.turnover, c.location
      ORDER BY c.id DESC
      LIMIT $${paramIndex} OFFSET $${paramIndex + 1}
    `;
    
    values.push(limitNum, offset);
    const dataResult = await pool.query(dataQuery, values);

    // Transform for Operations/Admin - apply status transformation
    let cases = dataResult.rows;
    if (["Operations", "Admin"].includes(user.rolename)) {
      const statusOrder = ["REJECT", "OPEN", "LOGIN", "PD", "SANCTIONED", "DISBURSEMENT", "DONE"];
      cases = cases.map(c => {
        // Check if case has bank assignments and determine display status
        if (c.bank_assignments && c.bank_assignments.length > 0 && c.status?.toLowerCase() === "one pager") {
          let highestStatusIndex = -1;
          for (const ba of c.bank_assignments) {
            const index = statusOrder.indexOf(ba.status?.toUpperCase());
            if (index > highestStatusIndex) {
              highestStatusIndex = index;
            }
          }
          if (highestStatusIndex >= 0) {
            c.display_status = statusOrder[highestStatusIndex];
          }
        }
        return c;
      });
    }

    res.json({
      cases,
      pagination: {
        page: pageNum,
        limit: limitNum,
        total,
        totalPages: Math.ceil(total / limitNum),
        hasMore: pageNum * limitNum < total
      }
    });
  } catch (err) {
    console.error("Get Cases List Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};