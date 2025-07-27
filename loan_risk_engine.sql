USE loan_risk_engine;
DROP TABLE IF EXISTS repayments;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;
-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    region VARCHAR(50),
    occupation VARCHAR(50),
    monthly_income DECIMAL(10,2)
);


-- Accounts table
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(30),
    balance DECIMAL(12,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Transactions table
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    amount DECIMAL(10,2),
    transaction_type VARCHAR(10),
    transaction_date DATE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- Loans table
CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_type VARCHAR(50),
    loan_amount DECIMAL(12,2),
    tenure_months INT,
    interest_rate DECIMAL(4,2),
    start_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Repayments table
CREATE TABLE repayments (
    repayment_id INT PRIMARY KEY,
    loan_id INT,
    paid_amount DECIMAL(10,2),
    due_amount DECIMAL(10,2),
    due_date DATE,
    paid_on DATE,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);
INSERT INTO customers VALUES 
(1, 'Anika Sharma', 32, 'Delhi', 'Engineer', 80000),
(2, 'Ravi Mehra', 45, 'Mumbai', 'Doctor', 150000),
(3, 'Sneha Jain', 28, 'Bangalore', 'Designer', 50000),
(4, 'Amit Verma', 50, 'Kolkata', 'Retired', 30000);
INSERT INTO accounts VALUES
(101, 1, 'Savings', 250000),
(102, 2, 'Savings', 600000),
(103, 3, 'Checking', 120000),
(104, 4, 'Savings', 80000);
INSERT INTO transactions VALUES
(1001, 101, 10000, 'debit', '2024-12-10'),
(1002, 102, 50000, 'debit', '2025-01-05'),
(1003, 103, 3000, 'credit', '2025-03-02'),
(1004, 104, 10000, 'debit', '2025-02-20');
INSERT INTO loans VALUES
(201, 1, 'Home Loan', 1200000, 240, 7.5, '2023-01-15'),
(202, 2, 'Car Loan', 600000, 60, 8.0, '2024-06-10'),
(203, 3, 'Personal Loan', 200000, 24, 10.5, '2025-02-01');
INSERT INTO repayments VALUES
(301, 201, 15000, 20000, '2025-01-10', '2025-01-11'),
(302, 201, 15000, 20000, '2025-02-10', '2025-02-12'),
(303, 202, 12000, 12000, '2025-01-10', '2025-01-09'),
(304, 203, 10000, 10000, '2025-02-15', NULL); -- missed payment
SELECT 
    c.name, l.loan_type, r.due_date, r.paid_on,
    DATEDIFF(r.paid_on, r.due_date) AS delay_days
FROM repayments r
JOIN loans l ON r.loan_id = l.loan_id
JOIN customers c ON l.customer_id = c.customer_id
WHERE r.paid_on IS NULL OR r.paid_on > r.due_date;
SELECT 
    c.name, c.monthly_income, SUM(l.loan_amount) AS total_loan
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_loan DESC;
SELECT 
    c.customer_id, c.name,
    COUNT(*) AS missed_or_late_payments
FROM repayments r
JOIN loans l ON r.loan_id = l.loan_id
JOIN customers c ON l.customer_id = c.customer_id
WHERE r.paid_on IS NULL OR r.paid_on > r.due_date
GROUP BY c.customer_id
HAVING missed_or_late_payments >= 2;


