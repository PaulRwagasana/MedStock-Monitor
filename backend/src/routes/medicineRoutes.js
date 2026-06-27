const express = require("express");
const router = express.Router();
const medicineController = require("../controllers/medicineController");

// ===============================
// Static Routes (Must come first)
// ===============================

// Get all medicines
router.get("/", medicineController.getAllMedicines);

// Search medicines
router.get("/search", medicineController.searchMedicine);

// Get low-stock medicines
router.get("/alerts/low-stock", medicineController.getLowStock);

// Get medicines by category
router.get("/category/:category", medicineController.getByCategory);

// ===============================
// Dynamic Routes
// ===============================

// Get medicine by ID
router.get("/:id", medicineController.getMedicineById);

// Create a new medicine
router.post("/", medicineController.createMedicine);

// Update a medicine
router.put("/:id", medicineController.updateMedicine);

// Delete a medicine
router.delete("/:id", medicineController.deleteMedicine);

// Add stock
router.patch("/:id/add-stock", medicineController.addStock);

// Reduce stock
router.patch("/:id/reduce-stock", medicineController.reduceStock);

module.exports = router;