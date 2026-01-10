const pool = require("../db");
const jwt = require("jsonwebtoken");

exports.register = async (req, res) => {
  const { email, password, phone, company, pocname, pocphone } = req.body;
  const name = req.body.name || company;

  try {
    const roleResult = await pool.query("SELECT id FROM roles WHERE rolename = $1", [req.body.rolename || "Individual"]);
    const roleid = roleResult.rows[0]?.id;
    if (!roleid) return res.status(400).json({ error: "Invalid role" });

    const hashedPassword = password;

    const userResult = await pool.query(
      "INSERT INTO users (name, email, password, phone, company, pocname, pocphone, roleid) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *",
      [name, email, hashedPassword, phone, company, pocname, pocphone, roleid]
    );

    const user = userResult.rows[0];

    // ✅ Prepare mock req/res to pass to createCase()
    const caseid = `C${Date.now()}`;
    const now = new Date().toISOString();
    const [date, time] = now.split("T");

    const fakeReq = {
      body: {
        caseid,
        companyname: company,
        clientname: "NA",
        role: "Individual",
        status: "Requirement Raised",
        companyemail: email,
        spocemail: email,
        spocname: pocname || "NA",
        spocphonenumber: pocphone || "NA",
        location: "NA",
        turnover: "",
        leadSource: "Website",
        date,
        time: time.replace("Z", ""),
        createddate: now,
        assigneddate: now,
        assignee: "KAM",
        comments: [],
        assigned_to: null // you can assign a default KAM if needed
      },
      user: { id: user.id }
    };

    const fakeRes = {
      status: code => ({
        json: data => console.log(`📦 Case created [status ${code}]:`, data)
      })
    };

    // ✅ Call createCase directly
    await require('./caseController').createCase(fakeReq, fakeRes);

    res.status(201).json({ message: "User registered and case created", user });
  } catch (err) {
    console.error("Register Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.login = async (req, res) => {
  const { login, password } = req.body;

  try {
    const result = await pool.query(
      `SELECT users.*, roles.rolename FROM users JOIN roles ON users.roleid = roles.id WHERE email = $1 OR phone = $1`,
      [login]
    );

    const user = result.rows[0];
    if (!user) return res.status(400).json({ error: "User not found" });

    if (password !== user.password) {
      return res.status(400).json({ error: "Invalid credentials" });
    }

    const tokenPayload = {
      id: user.id,
      email: user.email,
      name: user.name,
      rolename: user.rolename,
      roleid: user.roleid,
      company: user.company,
    };

    const token = jwt.sign(tokenPayload, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });

    // Return token in response body for frontend to store and use in Authorization header
    res.json({ message: "Login successful", user: tokenPayload, token });
  } catch (err) {
    console.error("Login Error:", err);
    res.status(500).json({ error: "Server error" });
  }
};

exports.me = async (req, res) => {
  const authHeader = req.headers["authorization"];
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ error: "No token provided" });
  }

  const token = authHeader.split(" ")[1];
  if (!token) return res.status(401).json({ error: "Not authenticated" });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    res.json({ user: decoded });
  } catch (err) {
    return res.status(403).json({ error: "Invalid or expired token" });
  }
};