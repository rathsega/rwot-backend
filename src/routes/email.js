const express = require("express");
const nodemailer = require("nodemailer");
const router = express.Router();

router.post("/send-email", async (req, res) => {
    // Remove CORS headers if needed
  res.removeHeader("Access-Control-Allow-Origin");
  res.removeHeader("Access-Control-Allow-Credentials");
  const { name, email, company, phone, message } = req.body;

  if (!name || !email || !message) {
    return res.status(400).json({ message: "Name, email, and message are required." });
  }

  const transporter = nodemailer.createTransport({
    service: "Gmail", // or "Mailgun", "SendGrid", etc.
    auth: {
      user: process.env.CONTACT_EMAIL_USER, // Your email
      pass: process.env.CONTACT_EMAIL_PASS, // Your email password or app password
    },
  });

  const mailOptions = {
    from: `"RWOT Contact" <${process.env.CONTACT_EMAIL_USER}>`,
    to: "operations@myrwot.com", // destination email
    subject: `New Contact Message from ${name}`,
    html: `
      <h3>New Contact Submission</h3>
      <p><strong>Name:</strong> ${name}</p>
      <p><strong>Email:</strong> ${email}</p>
      <p><strong>Company:</strong> ${company || 'N/A'}</p>
      <p><strong>Phone:</strong> ${phone || 'N/A'}</p>
      <p><strong>Message:</strong><br/>${message}</p>
    `,
  };

  try {
    await transporter.sendMail(mailOptions);
    res.json({ message: "Message sent successfully!" });
  } catch (error) {
    console.error("Error sending email:", error);
    res.status(500).json({ message: "Failed to send email. Please try again later." });
  }
});

module.exports = router;