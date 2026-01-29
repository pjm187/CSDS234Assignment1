-- Paul_234_A1.sql

-- Drop tables if they already exist
-- Order matters due to foreign key dependencies
DROP TABLE IF EXISTS lab_results;
DROP TABLE IF EXISTS diagnoses;
DROP TABLE IF EXISTS medications;
DROP TABLE IF EXISTS visits;
DROP TABLE IF EXISTS users;

-- USERS table
-- Stores basic demographic information
CREATE TABLE users (
  user_id INT PRIMARY KEY,                  -- Unique user identifier
  name TEXT NOT NULL,                       -- User full name
  age INT CHECK (age >= 0),                  -- Age must be positive
  gender TEXT NOT NULL CHECK (gender IN ('M','F')), -- Gender constraint
  city TEXT NOT NULL                        -- City of residence
);

-- Insert sample users 
INSERT INTO users(user_id, name, age, gender, city) VALUES
  (1, 'Alex Chen', 29, 'M', 'Cleveland'),
  (2, 'Priya Iyer', 34, 'F', 'Cleveland'),
  (3, 'Sam Lee', 41, 'M', 'Beachwood'),
  (5, 'Jordan Smith', 31, 'M', 'Shaker Heights'),
  (9, 'Ethan Brooks', 45, 'M', 'Solon');
  
-- Verify users table contents
SELECT * FROM users;

-- VISITS table
-- Each visit references a valid user

CREATE TABLE visits (
  visit_id INT PRIMARY KEY,                 -- Unique visit identifier
  user_id INT NOT NULL REFERENCES users(user_id), -- Foreign key to users
  visit_date DATE NOT NULL CHECK (visit_date::TEXT ~ '^\d{4}-\d{2}-\d{2}$'), -- Visit Date of visit
  provider TEXT NOT NULL CHECK (provider LIKE 'Dr.%') -- Provider naming rule
);

-- Insert visit records
INSERT INTO visits(visit_id, user_id, visit_date, provider) VALUES
  (101, 1, '2026-01-10', 'Dr.Smith'),
  (102, 2, '2026-01-12', 'Dr.Patel'),
  (103, 3, '2026-01-15', 'Dr.Gomez'),
  (105, 5, '2026-01-20', 'Dr.Patel'),
  (110, 9, '2026-02-08', 'Dr.Ahmed');

-- Verify visits table contents
SELECT * FROM visits;

-- DIAGNOSES table
-- Each diagnosis is linked to a visit
CREATE TABLE diagnoses (
  diag_id INT PRIMARY KEY,                  -- Diagnosis identifier
  visit_id INT NOT NULL REFERENCES visits(visit_id), -- FK to visits
  code TEXT NOT NULL,                       -- Diagnosis code (e.g., ICD)
  description TEXT NOT NULL                 -- Diagnosis description
);

-- Insert diagnosis records
INSERT INTO diagnoses(diag_id, visit_id, code, description) VALUES
  (1001, 101, 'R53', 'Fatigue'),
  (1003, 102, 'I10', 'Hypertension'),
  (1004, 103, 'E11', 'Type 2 diabetes'),
  (1006, 105, 'E66', 'Obesity'),
  (1010, 110, 'I10', 'Hypertension');

-- Verify diagnoses table contents
SELECT * FROM diagnoses;


-- MEDICATIONS table
-- Tracks medications prescribed to users
CREATE TABLE medications (
  med_id INT PRIMARY KEY,                   -- Medication record ID
  user_id INT NOT NULL REFERENCES users(user_id), -- FK to users
  drug_name TEXT NOT NULL,                  -- Medication name
  dose TEXT NOT NULL,                       -- Dosage information
  start_date DATE NOT NULL CHECK (start_date::TEXT ~ '^\d{4}-\d{2}-\d{2}$') -- Start Date of visit
);

-- Insert medication records
INSERT INTO medications(med_id, user_id, drug_name, dose, start_date) VALUES
  (2001, 2, 'Lisinopril', '10 mg', '2026-01-12'),
  (2002, 3, 'Metformin', '500 mg', '2026-01-15'),
  (2003, 1, 'Ibuprofen', '200 mg', '2026-01-10'),
  (2008, 5, 'Orlistat', '120 mg', '2026-01-20'),
  (2006, 9, 'Lisinopril', '5 mg', '2026-02-18');

-- Verify medications table contents
SELECT * FROM medications;


-- LAB_RESULTS table
-- Stores laboratory test measurements
CREATE TABLE lab_results (
  lab_id INT PRIMARY KEY,                   -- Lab test identifier
  user_id INT NOT NULL REFERENCES users(user_id), -- FK to users
  test_name TEXT NOT NULL,                  -- Name of test
  value DOUBLE PRECISION CHECK (value >= 0), -- Numeric result value
  unit TEXT NOT NULL,                       -- Measurement unit
  test_date DATE NOT NULL CHECK (test_date::TEXT ~ '^\d{4}-\d{2}-\d{2}$')
);

-- Insert lab test results
INSERT INTO lab_results(lab_id, user_id, test_name, value, unit, test_date) VALUES
  (3001, 2, 'BloodPressureSys', 145.0, 'mmHg', '2026-01-12'),
  (3002, 2, 'BloodPressureDia', 92.0, 'mmHg', '2026-01-12'),
  (3003, 3, 'Glucose', 180.0, 'mg/dL', '2026-01-10'),
  (3007, 9, 'BloodPressureSys', 155.0, 'mmHg', '2026-02-08'),
  (3009, 5, 'BMI', 33.2, 'kg/m^2', '2026-02-10');

-- Verify lab results table contents
SELECT * FROM lab_results;