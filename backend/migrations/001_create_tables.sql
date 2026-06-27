-- Create medicines table
CREATE TABLE medicines (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 0,
    threshold INTEGER NOT NULL DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert some initial seed data for testing
INSERT INTO medicines (name, category, quantity, threshold)
VALUES
('Paracetamol', 'Analgesics', 120, 20),

('Amoxicillin', 'Antibiotics', 30, 15),

('Coartem', 'Antimalarials', 8, 10),

('Ibuprofen', 'Analgesics', 65, 20),

('Metformin', 'Diabetes', 40, 15);