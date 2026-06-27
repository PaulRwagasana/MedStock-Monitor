const medicineService = require("../services/medicineService");

// Get all medicines
const getAllMedicines = async (req, res) => {
  try {
    const medicines = await medicineService.getAllMedicines();

    res.status(200).json({
      success: true,
      data: medicines,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get medicine by ID
const getMedicineById = async (req, res) => {
  try {
    const medicine = await medicineService.getMedicineById(req.params.id);

    res.status(200).json({
      success: true,
      data: medicine,
    });
  } catch (error) {
    res.status(404).json({
      success: false,
      message: error.message,
    });
  }
};

// Add new medicine
const addMedicine = async (req, res) => {
  try {
    const medicine = await medicineService.addMedicine(req.body);

    res.status(201).json({
      success: true,
      message: "Medicine added successfully",
      data: medicine,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Update medicine
const updateMedicine = async (req, res) => {
  try {
    const medicine = await medicineService.updateMedicine(
      req.params.id,
      req.body
    );

    res.status(200).json({
      success: true,
      message: "Medicine updated successfully",
      data: medicine,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Delete medicine
const deleteMedicine = async (req, res) => {
  try {
    const result = await medicineService.deleteMedicine(req.params.id);

    res.status(200).json({
      success: true,
      message: result.message,
    });
  } catch (error) {
    res.status(404).json({
      success: false,
      message: error.message,
    });
  }
};

// Increase stock
const addStock = async (req, res) => {
  try {
    const { amount } = req.body;

    const medicine = await medicineService.addStock(
      req.params.id,
      amount
    );

    res.status(200).json({
      success: true,
      message: "Stock added successfully",
      data: medicine,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Reduce stock
const reduceStock = async (req, res) => {
  try {
    const { amount } = req.body;

    const medicine = await medicineService.reduceStock(
      req.params.id,
      amount
    );

    res.status(200).json({
      success: true,
      message: "Stock reduced successfully",
      data: medicine,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

// Get low stock medicines
const getLowStock = async (req, res) => {
  try {
    const medicines = await medicineService.getLowStock();

    res.status(200).json({
      success: true,
      data: medicines,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get medicines by category
const getByCategory = async (req, res) => {
  try {
    const medicines = await medicineService.getByCategory(
      req.params.category
    );

    res.status(200).json({
      success: true,
      data: medicines,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Search medicines
const searchMedicine = async (req, res) => {
  try {
    const { name } = req.query;

    if (!name || name.trim() === "") {
      return res.status(400).json({
        success: false,
        message: "Search term is required",
      });
    }

    const medicines = await medicineService.searchMedicine(name);

    res.status(200).json({
      success: true,
      data: medicines,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

module.exports = {
  getAllMedicines,
  getMedicineById,
  addMedicine,
  updateMedicine,
  deleteMedicine,
  addStock,
  reduceStock,
  getLowStock,
  getByCategory,
  searchMedicine,
};