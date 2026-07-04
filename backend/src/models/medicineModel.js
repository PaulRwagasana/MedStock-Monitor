const db = require("../config/db");

// Get all medicines
const getAllMedicines = async () => {
  const result = await db.query(
    "SELECT * FROM medicines ORDER BY id ASC"
  );

  return result.rows;
};

// Get one medicine
const getMedicineById = async (id) => {
  const result = await db.query(
    "SELECT * FROM medicines WHERE id = $1",
    [id]
  );

  return result.rows[0];
};

// Add medicine
const addMedicine = async (medicine) => {
  const { name, category, quantity, threshold, unit } = medicine;

  const result = await db.query(
    `INSERT INTO medicines
    (name, category, quantity, threshold, unit)
    VALUES ($1,$2,$3,$4,$5)
    RETURNING *`,
    [name, category, quantity, threshold, unit]
  );

  return result.rows[0];
};

// Update medicine
const updateMedicine = async (id, medicine) => {
  const { name, category, quantity, threshold } = medicine;

  const result = await db.query(
    `UPDATE medicines
     SET
     name=$1,
     category=$2,
     quantity=$3,
     threshold=$4
     WHERE id=$5
     RETURNING *`,
    [name, category, quantity, threshold, id]
  );

  return result.rows[0];
};

// Delete medicine
const deleteMedicine = async (id) => {
  await db.query(
    "DELETE FROM medicines WHERE id=$1",
    [id]
  );
};

// Increase stock
const addStock = async (id, amount) => {
  const result = await db.query(
    `UPDATE medicines
     SET quantity = quantity + $1
     WHERE id=$2
     RETURNING *`,
    [amount, id]
  );

  return result.rows[0];
};

// Reduce stock
const reduceStock = async (id, amount) => {
  const result = await db.query(
    `UPDATE medicines
     SET quantity = quantity - $1
     WHERE id=$2
     RETURNING *`,
    [amount, id]
  );

  return result.rows[0];
};

// Low stock medicines
const getLowStock = async () => {
  const result = await db.query(
    "SELECT * FROM medicines WHERE quantity <= threshold"
  );

  return result.rows;
};

// Medicines by category
const getByCategory = async (category) => {
  const result = await db.query(
    "SELECT * FROM medicines WHERE category=$1",
    [category]
  );

  return result.rows;
};

// Search medicines by name
const searchMedicine = async (name) => {
  const result = await db.query(
    `SELECT * FROM medicines
     WHERE LOWER(name)
     LIKE LOWER($1)`,
    [`%${name}%`]
  );

  return result.rows;
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
}