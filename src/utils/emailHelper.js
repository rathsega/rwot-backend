const nodemailer = require('nodemailer');

/**
 * Create reusable transporter using Gmail
 * Make sure to use your Gmail address and App Password
 */
const transporter = nodemailer.createTransport({
  host: 'smtp.gmail.com',
  port: 465,
  secure: true,
  auth: {
    user: process.env.GOOGLE_APP_EMAIL,
    pass: process.env.GOOGLE_APP_PASSWORD
  },
  tls: {
    rejectUnauthorized: false
  }
});

/**
 * Send email helper
 * @param {string} from - sender email
 * @param {string|string[]} to - recipient(s)
 * @param {string} subject - email subject
 * @param {string} text - plain text body
 * @param {string} html - html body (optional)
 * @param {Array} attachments - attachments (optional)
 */
async function sendEmailNotification({ from, to, subject, text, html, attachments }) {
  try {
    const info = await transporter.sendMail({
      from,
      to: 'sekhar5b0@gmail.com',
      subject,
      text,
      html,
      attachments
    });
    console.log('Email sent:', info.messageId);
  } catch (err) {
    console.error('Error sending email:', err);
  }
}

module.exports = { sendEmailNotification };