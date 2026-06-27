const checkLowStock = (medicines) => {
  return medicines.filter((medicine) => {
    return medicine.quantity <= medicine.threshold;
  });
};

module.exports = {
  checkLowStock,
};