const medicineModel = require("../models/medicineModel");

// Get all medicines
const getAllMedicines = async () => {
  return await medicineModel.getAllMedicines();
};

// Get one medicine
const getMedicineById = async (id) => {
  const medicine = await medicineModel.getMedicineById(id);

  if (!medicine) {
    throw new Error("Medicine not found");
  }

  return medicine;
};

// Add new medicine
const addMedicine = async (medicine) => {
  const { name, category, quantity, threshold, unit } = medicine;

  if (!name || !category) {
    throw new Error("Name and category are required");
  }

  return await medicineModel.addMedicine({
    name,
    category,
    quantity: quantity || 0,
    threshold: threshold || 10,
    unit: unit || 'units',
  });
};

// Update medicine
const updateMedicine = async (id, medicine) => {
  const existingMedicine = await medicineModel.getMedicineById(id);

  if (!existingMedicine) {
    throw new Error("Medicine not found");
  }

  return await medicineModel.updateMedicine(id, medicine);
};

// Delete medicine
const deleteMedicine = async (id) => {
  const existingMedicine = await medicineModel.getMedicineById(id);

  if (!existingMedicine) {
    throw new Error("Medicine not found");
  }

  await medicineModel.deleteMedicine(id);

  return {
    message: "Medicine deleted successfully",
  };
};

// Increase stock
const addStock = async (id, amount) => {
  const existingMedicine = await medicineModel.getMedicineById(id);

  if (!existingMedicine) {
    throw new Error("Medicine not found");
  }

  if (amount <= 0) {
    throw new Error("Amount must be greater than zero");
  }

  return await medicineModel.addStock(id, amount);
};

// Reduce stock
const reduceStock = async (id, amount) => {
  const existingMedicine = await medicineModel.getMedicineById(id);

  if (!existingMedicine) {
    throw new Error("Medicine not found");
  }

  if (amount <= 0) {
    throw new Error("Amount must be greater than zero");
  }

  if (existingMedicine.quantity < amount) {
    throw new Error("Not enough stock available");
  }

  return await medicineModel.reduceStock(id, amount);
};

// Get low stock medicines
const getLowStock = async () => {
  return await medicineModel.getLowStock();
};

// Get medicines by category
const getByCategory = async (category) => {
  return await medicineModel.getByCategory(category);
};

// Search medicines
const searchMedicine = async (name) => {
  return await medicineModel.searchMedicine(name);
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