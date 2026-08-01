const express = require("express");
const cors = require("cors");

const medicineRoutes = require("./src/routes/medicineRoutes");
const errorHandler = require("./src/middlewares/errorHandler");
const pool = require("./src/config/db");

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Home Route
app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "Welcome to MedStock Monitor API",
  });
});

// Health Check
app.get("/health", async (req, res) => {
  try {
    await pool.query("SELECT 1");
    res.json({ status: "ok", db: "connected" });
  } catch {
    res.status(503).json({ status: "error", db: "unreachable" });
  }
});

// API Routes
app.use("/api/medicines", medicineRoutes);

// Handle unknown routes
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: "Route not found",
  });
});

// Error Middleware
app.use(errorHandler);

module.exports = app;