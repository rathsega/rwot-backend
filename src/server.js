const express = require("express");
const cors = require("cors");
const cookieParser = require("cookie-parser");
const dotenv = require("dotenv");
dotenv.config();

const authRoutes = require("./routes/auth");
const caseRoutes = require("./routes/caseRoutes");
const commentRoutes = require("./routes/commentRoutes");
const documentRoutes = require("./routes/documentRoutes");
const workflowRoutes = require("./routes/workflowRoutes");
const bankRoutes = require("./routes/bankRoutes");
const assignmentRoutes = require("./routes/caseAssignmentRoutes");
const userRoutes = require("./routes/user");
const profileRoutes = require("./routes/profile");
const emailRoutes = require("./routes/email");
const settingsRoutes = require("./routes/settingsRoutes");

const app = express();
const PORT = process.env.PORT || 5001;

// app.use(cors({
//   origin: "http://localhost:3000", 
//   credentials: true
// }));
const allowedOrigins = ['https://rwot.in', 'https://www.rwot.in', 'http://localhost:3000'];

app.use(cors({
  origin: function(origin, callback) {
    console.log(origin);
    if (!origin || allowedOrigins.includes(origin)) {
      return callback(null, true);
    } else {
      return callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

app.use("/api/send-email", emailRoutes)

app.use("/api/auth", authRoutes);
app.use("/api/cases", caseRoutes);
app.use("/api/comments", commentRoutes);
app.use("/api/documents", documentRoutes);
app.use("/api/workflow", workflowRoutes);
app.use("/api/banks", bankRoutes);
app.use("/api/cases/assign", assignmentRoutes);
app.use("/api/users", userRoutes);
app.use("/api/profile", profileRoutes);
app.use("/api/settings", settingsRoutes);
app.use("/api", require("./routes/email"));

app.use("/api/roles", require("./routes/roles"));

app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));