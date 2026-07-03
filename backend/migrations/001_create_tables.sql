-- Create medicines table
CREATE TABLE medicines (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 0,
    threshold INTEGER NOT NULL DEFAULT 10,
    unit VARCHAR(50) NOT NULL DEFAULT 'units',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert some initial seed data for testing
INSERT INTO medicines (name, category, quantity, threshold, unit)
VALUES
('Paracetamol', 'Analgesics', 120, 20, 'tablets'),

('Amoxicillin', 'Antibiotics', 30, 15, 'capsules'),

('Coartem', 'Antimalarials', 8, 10, 'tablets'),

('Ibuprofen', 'Analgesics', 65, 20, 'tablets'),

('Metformin', 'Diabetes', 40, 15, 'tablets');