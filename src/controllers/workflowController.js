const pool = require("../db");

// POST: Update case stage and log it in workflow
exports.updateStage = async (req, res) => {
  const { caseid, stage } = req.body;
  const updatedAt = new Date().toISOString();

  try {
    // Log the workflow stage update
    await pool.query(
      "INSERT INTO workflow (caseid, stage) VALUES ($1, $2)",
      [caseid, stage]
    );

    // Update the current stage in the cases table
    await pool.query(
      "UPDATE cases SET stage = $1, status = $2, updatedat = $3 WHERE caseid = $4",
      [stage, stage, updatedAt, caseid]
    );

    // Fetch current case details
    const caseRes = await pool.query("SELECT * FROM cases WHERE caseid = $1", [caseid]);
    const currentCase = caseRes.rows[0];
    if (!currentCase) return res.status(404).json({ error: "Case not found" });

    // Assignment logic based on stage
    if (stage === "KAM Review") {
      // Assigned by Telecaller to KAM, now also assign to Operations
      const opsUser = await pool.query(
        `SELECT id FROM users WHERE roleid = (SELECT id FROM roles WHERE rolename = 'Operations') LIMIT 1`
      );
      if (opsUser.rows.length > 0) {
        await pool.query(
          `INSERT INTO case_assignments (caseid, assigned_to) VALUES ($1, $2) ON CONFLICT DO NOTHING`,
          [caseid, opsUser.rows[0].id]
        );
      }
    } else if (stage === "Underwriting" || stage === "Underwriter") {
      // Assigned by Operations to Underwriter
      const uwUser = await pool.query(
        `SELECT id FROM users WHERE roleid = (SELECT id FROM roles WHERE rolename = 'UW') LIMIT 1`
      );
      if (uwUser.rows.length > 0) {
        await pool.query(
          `INSERT INTO case_assignments (caseid, assigned_to, role) VALUES ($1, $2, $3) ON CONFLICT DO NOTHING`,
          [caseid, uwUser.rows[0].id, 'UW']
        );
      }
    } else if (stage === "Ready to Share") {
      // No assignment change, case remains in Operations
    } else if (stage === "Banker Review") {
      const selectedBankIds = req.body.banks || [];  // should be array of bank IDs
      for (const bankId of selectedBankIds) {
        const bank = await pool.query("SELECT * FROM banks WHERE id = $1", [bankId]);
        if (bank.rows.length > 0) {
          const bankUserEmail = bank.rows[0].email;
          const assignedUser = await pool.query("SELECT id FROM users WHERE email = $1", [bankUserEmail]);
          if (assignedUser.rows.length > 0) {
            await pool.query(
              `INSERT INTO case_assignments (caseid, assigned_to, role) VALUES ($1, $2, $3) ON CONFLICT DO NOTHING`,
              [caseid, assignedUser.rows[0].id, "Banker"]
            );
          }
        }
      }
    }

    res.status(200).json({ message: `Stage '${stage}' updated for case ${caseid}` });
  } catch (err) {
    console.error("Update Stage Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// GET: Get all stage history for a case
exports.getStageHistory = async (req, res) => {
  const { caseid } = req.params;

  try {
    const result = await pool.query(
      "SELECT * FROM workflow WHERE caseid = $1 ORDER BY timestamp ASC",
      [caseid]
    );
    res.status(200).json({ workflow: result.rows });
  } catch (err) {
    console.error("Get Stage History Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// GET: Get latest stage (current stage)
exports.getCurrentStage = async (req, res) => {
  const { caseid } = req.params;

  try {
    const result = await pool.query(
      "SELECT * FROM workflow WHERE caseid = $1 ORDER BY timestamp DESC LIMIT 1",
      [caseid]
    );

    res.status(200).json({ currentStage: result.rows[0]?.stage || "Not Started" });
  } catch (err) {
    console.error("Get Current Stage Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
