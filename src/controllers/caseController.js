const pool = require("../db");
const { sendEmail, sendWhatsApp } = require("../utils/notifications");

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
    leadSource,
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
  const finalLeadSource = role === "Individual" ? "Website" : leadSource;

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

      // await sendEmail(kamEmail, "New Lead Assigned", `You have a new case assigned: ${caseid}`);
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

    res.status(201).json({ message: "Case created" });
  } catch (err) {
    console.error("Create Case Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Get cases with documents, comments, and KAM assignment
exports.getCases = async (req, res) => {
  const userId = req.user.id;
  try {
    const userResult = await pool.query(
      `SELECT users.*, roles.rolename FROM users JOIN roles ON users.roleid = roles.id WHERE users.id = $1`,
      [userId]
    );
    const user = userResult.rows[0];

    let query = `
      SELECT c.*, u.name AS assigned_to_name, u.email AS assigned_to_email, u.phone, ca.role AS assigned_to_role
      FROM cases c
      LEFT JOIN case_assignments ca ON ca.caseid = c.caseid
      LEFT JOIN users u ON u.id = ca.assigned_to`;
    let values = [];

    if (user.rolename === "Admin") {
      query += ` ORDER BY c.id DESC`;
    } else if (user.rolename === "Individual") {
      // ✅ Show only cases assigned to this individual's email
      query += ` WHERE c.role = 'Individual' AND LOWER(c.assignee) = LOWER($1) ORDER BY c.id DESC`;
      values.push(user.email);
    } else if (
      user.rolename === "Banker" ||
      user.rolename === "Telecaller" ||
      user.rolename === "UW" ||
      user.rolename === "Operations" ||
      user.rolename === "KAM"
    ) {
      // ✅ Show all cases mapped to this role (not by user ID)
      query += ` WHERE ca.role = $1 ORDER BY c.id DESC`;
      values.push(user.rolename);
    } else {
      query += ` WHERE ca.assigned_to = $1 ORDER BY c.id DESC`;
      values.push(userId);
    }

    const result = await pool.query(query, values);
    const cases = result.rows;

    for (const c of cases) {
      const docsResult = await pool.query(`SELECT * FROM documents WHERE caseid = $1 ORDER BY uploadedat DESC`, [c.caseid]);
      const allDocs = docsResult.rows;

      const latestOnePager = allDocs.find(d => d.doctype === "onePager");
      const filteredDocs = [
        ...allDocs.filter(d => d.doctype !== "onePager"),
        ...(latestOnePager ? [latestOnePager] : [])
      ];
      c.documents = filteredDocs;

      const comments = await pool.query(`SELECT * FROM comments WHERE caseid = $1 ORDER BY created_at DESC`, [c.caseid]);
      c.comments = comments.rows;

      const bankResult = await pool.query(`SELECT * FROM banks WHERE name = $1 LIMIT 1`, [c.bankname]);
      c.bankDetails = bankResult.rows[0] || null;
    }

    res.json({ cases });
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
if (comments?.trim()) {
  const userInfo = await pool.query("SELECT name, email FROM users WHERE id = $1", [req.user.id]);
  const user = userInfo.rows[0];
  const commentby = user?.name || user?.email || "User";

  await pool.query(
    `INSERT INTO comments (caseid, comment, role, created_at, commentby)
     VALUES ($1, $2, $3, NOW(), $4)`,
    [caseid, comments.trim(), req.user.rolename || "Unknown", commentby]
  );
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
  const { status } = req.body;

  try {
    if (!status) return res.status(400).json({ error: "Missing status field" });

    await pool.query(
      `UPDATE cases SET status = $1, updatedat = NOW() WHERE caseid = $2`,
      [status, caseid]
    );

    return res.json({ message: `Status updated to '${status}' for case ${caseid}` });
  } catch (err) {
    console.error("Update Case Status Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// POST: Get cases by role (e.g., for /cases/by-role)
exports.getCasesByRole = async (req, res) => {
  const { role } = req.body;

  try {
    if (!role) return res.status(400).json({ error: "Missing role field" });

    const result = await pool.query(
      `SELECT * FROM cases WHERE role = $1 ORDER BY id DESC`,
      [role]
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

    const result = await pool.query(`SELECT * FROM cases WHERE caseid = $1`, [caseid]);
    const caseData = result.rows[0];

    if (!caseData) {
      return res.status(404).json({ message: "Case not found" });
    }

    // Fetch documents and comments
    const docsRes = await pool.query(`SELECT * FROM documents WHERE caseid = $1`, [caseid]);
    const commentsRes = await pool.query(`SELECT * FROM comments WHERE caseid = $1`, [caseid]);

    caseData.documents = docsRes.rows;
    caseData.comments = commentsRes.rows;

    res.json(caseData);
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
        role || "Telecaller",
        bankname,
        stage,
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

if (comments?.trim()) {
  const userInfo = await pool.query("SELECT name, email FROM users WHERE id = $1", [req.user.id]);
  const user = userInfo.rows[0];
  const commentby = user?.name || user?.email || "User";

  await pool.query(
    `INSERT INTO comments (caseid, comment, role, created_at, commentby)
     VALUES ($1, $2, $3, NOW(), $4)`,
    [caseid, comments.trim(), req.user.rolename || "Unknown", commentby]
  );
}

    res.json({ message: "Case updated successfully" });
  } catch (err) {
    console.error("Edit Case Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};