const express = require("express");
const cors = require("cors");

const medicineRoutes = require("./src/routes/medicineRoutes");
const errorHandler = require("./src/middlewares/errorHandler");

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