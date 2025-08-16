const nodemailer = require("nodemailer");
const axios = require("axios");

// Send email to KAM
exports.sendEmail = async (to, subject, text) => {
  try {
    const transporter = nodemailer.createTransport({
      service: "gmail", // or your SMTP service
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      }
    });

    const mailOptions = {
      from: process.env.EMAIL_USER,
      to,
      subject,
      text
    };

    const info = await transporter.sendMail(mailOptions);
    console.log("Email sent:", info.response);
    return info;
  } catch (err) {
    console.error("Email error:", err.message);
    throw err;
  }
};

// Send WhatsApp message using Gupshup or Twilio (Gupshup example)
exports.sendWhatsApp = async (phoneNumber, message) => {
  try {
    const payload = {
      channel: "whatsapp",
      source: process.env.GUPSHUP_SOURCE_NUMBER,
      destination: phoneNumber,
      message: { type: "text", text: message }
    };

    const headers = {
      "Content-Type": "application/json",
      "apikey": process.env.GUPSHUP_API_KEY
    };

    const res = await axios.post(
      "https://api.gupshup.io/sm/api/v1/msg",
      payload,
      { headers }
    );

    console.log("WhatsApp sent:", res.data);
    return res.data;
  } catch (err) {
    console.error("WhatsApp error:", err.message);
    throw err;
  }
};