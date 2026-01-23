const { all } = require("axios");
const pool = require("../db");
const { sendEmail, sendWhatsApp } = require("../utils/notifications");
const { sendEmailNotification } = require("../utils/emailHelper");

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

      const operationsUser = await pool.query("SELECT id FROM users WHERE roleid = (SELECT id FROM roles WHERE rolename = 'Operations') LIMIT 1");
      const operationsUserId = operationsUser.rows[0]?.id;
      if (operationsUserId) {
        await pool.query(
          `INSERT INTO case_assignments (caseid, assigned_to, role)
           VALUES ($1, $2, $3)
           ON CONFLICT (caseid, role) DO UPDATE SET assigned_to = EXCLUDED.assigned_to`,
          [caseid, operationsUserId, "Operations"]
        );
      }
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
    } else if (user.rolename === "KAM") {
      whereClause = ` WHERE EXISTS (SELECT 1 FROM case_assignments ca WHERE ca.caseid = c.caseid AND ca.role = 'KAM' AND ca.assigned_to = $${paramIndex})`;
      values.push(userId);
    } else if (user.rolename === "Telecaller") {
      whereClause = ` WHERE c.createdby = $${paramIndex}`;
      values.push(userId);
    } else if (user.rolename === "Operations") {
      whereClause = ` WHERE LOWER(c.status) IN (
        'open', 'meeting done', 'documentation initiated', 'documentation in progress', 
        'underwriting', 'one pager', 'banker review', 'no requirement'
      )`;
    }
    // Admin and UW see all cases (no WHERE clause for counts)

    const countQuery = `
      SELECT 
        c.status,
        COUNT(DISTINCT c.caseid) as count
      FROM cases c
      ${whereClause}
      GROUP BY c.status
    `;

    const result = await pool.query(countQuery, values);
    
    // Convert to object for easier frontend use
    const counts = {};
    let total = 0;
    result.rows.forEach(row => {
      counts[row.status] = parseInt(row.count, 10);
      total += parseInt(row.count, 10);
    });
    counts.total = total;

    res.json({ counts });
  } catch (err) {
    console.error("Get Case Counts Error:", err);
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
          query += `  WHERE LOWER(c.status) in  ('one pager', 'underwriting', 'completed', 'closed', 'rejected', 'disbursed','pd', 'sanctioned', 'done', 'accept', 'login') or ca.role = 'Banker' ORDER BY c.id DESC`;
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
      query += ` WHERE LOWER(c.status) in  ('one pager', 'underwriting', 'completed', 'closed', 'rejected', 'disbursed','pd', 'sanctioned', 'done', 'accept', 'login') or ca.role = 'Banker' ORDER BY c.id DESC`;
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
        'login'
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

    // If case is assigned to a banker then keep that status as Banker Review and status is not completed or closed or rejected or disbursed or sanctioned or Done
    for (const c of cases) {
      if (c.assigned_to_role === "Banker" && !["completed", "closed", "rejected", "disbursed", "sanctioned", "Done"].includes(c.status)) {
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

    await pool.query(
      `UPDATE cases SET status = $1, updatedat = NOW(), status_updated_on = NOW() WHERE caseid = $2`,
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