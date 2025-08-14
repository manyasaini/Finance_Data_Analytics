-- Create Database
CREATE DATABASE LoanManagement;
USE LoanManagement;

-- Table: Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(50),
    city VARCHAR(50),
    join_date DATE
);

-- Table: Loans
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_type VARCHAR(20), -- Home, Car, Personal
    principal DECIMAL(10,2),
    interest_rate DECIMAL(5,2),
    start_date DATE,
    term_months INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Table: Repayments
CREATE TABLE Repayments (
    repayment_id INT PRIMARY KEY,
    loan_id INT,
    payment_date DATE,
    amount_paid DECIMAL(10,2),
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

-- Table: Penalties
CREATE TABLE Penalties (
    penalty_id INT PRIMARY KEY,
    loan_id INT,
    penalty_date DATE,
    penalty_amount DECIMAL(10,2),
    reason VARCHAR(100),
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

-- Insert Customers (10 sample)
INSERT INTO Customers VALUES
(1, 'Amit Sharma', 'Mumbai', '2020-01-10'),
(2, 'Priya Verma', 'Delhi', '2020-03-15'),
(3, 'Ravi Kumar', 'Bangalore', '2020-05-20'),
(4, 'Sneha Gupta', 'Pune', '2020-07-25'),
(5, 'Vikas Singh', 'Kolkata', '2020-09-30'),
(6, 'Meera Iyer', 'Chennai', '2020-11-05'),
(7, 'Karan Malhotra', 'Jaipur', '2021-01-12'),
(8, 'Pooja Sharma', 'Lucknow', '2021-02-18'),
(9, 'Rajesh Mehta', 'Ahmedabad', '2021-04-22'),
(10, 'Ananya Roy', 'Hyderabad', '2021-06-28');

-- Insert Loans (15 sample)
INSERT INTO Loans VALUES
(101, 1, 'Home', 5000000, 7.50, '2021-01-15', 240),
(102, 2, 'Car', 800000, 9.00, '2021-03-10', 60),
(103, 3, 'Personal', 300000, 12.00, '2021-05-05', 36),
(104, 4, 'Home', 4000000, 7.20, '2021-07-01', 240),
(105, 5, 'Car', 900000, 8.50, '2021-09-15', 60),
(106, 6, 'Personal', 500000, 11.50, '2021-11-20', 48),
(107, 7, 'Home', 3500000, 7.80, '2022-01-25', 240),
(108, 8, 'Car', 750000, 9.20, '2022-03-12', 60),
(109, 9, 'Personal', 450000, 12.50, '2022-05-19', 36),
(110, 10, 'Home', 6000000, 7.00, '2022-07-30', 240),
(111, 1, 'Car', 700000, 8.80, '2022-09-01', 60),
(112, 2, 'Personal', 350000, 11.00, '2022-10-05', 36),
(113, 3, 'Home', 4500000, 7.30, '2022-11-20', 240),
(114, 4, 'Car', 850000, 9.50, '2023-01-15', 60),
(115, 5, 'Personal', 400000, 12.20, '2023-02-20', 36);

-- Insert Repayments (20 sample)
INSERT INTO Repayments VALUES
(1, 101, '2023-04-05', 50000),
(2, 102, '2023-04-10', 15000),
(3, 103, '2023-04-15', 12000),
(4, 104, '2023-04-20', 45000),
(5, 105, '2023-04-25', 16000),
(6, 106, '2023-05-02', 14000),
(7, 107, '2023-05-07', 48000),
(8, 108, '2023-05-12', 15500),
(9, 109, '2023-05-17', 12500),
(10, 110, '2023-05-22', 60000),
(11, 111, '2023-05-27', 14500),
(12, 112, '2023-06-01', 13000),
(13, 113, '2023-06-06', 47000),
(14, 114, '2023-06-11', 15000),
(15, 115, '2023-06-16', 14000),
(16, 101, '2023-07-05', 50000),
(17, 102, '2023-07-10', 15000),
(18, 103, '2023-07-15', 12000),
(19, 104, '2023-07-20', 45000),
(20, 105, '2023-07-25', 16000);

-- Insert Penalties (5 sample)
INSERT INTO Penalties VALUES
(1, 103, '2023-05-20', 500, 'Late Payment'),
(2, 106, '2023-06-05', 800, 'Late Payment'),
(3, 109, '2023-07-02', 600, 'Late Payment'),
(4, 112, '2023-07-18', 750, 'Late Payment'),
(5, 115, '2023-07-25', 900, 'Late Payment');

-- 1. View all customers, Loans, Repayments and Penalties
SELECT * FROM Customers;
SELECT * FROM Loans ;
SELECT * FROM Repayments ;
SELECT * FROM Penalties;

-- 2. Show all loans of type 'Home'
SELECT * FROM Loans
WHERE loan_type = 'Home';

-- 3. Find customers from 'Mumbai'
SELECT * FROM Customers
WHERE city = 'Mumbai';

-- 4. Sort loans by principal amount in descending order
SELECT * FROM Loans
ORDER BY principal DESC;

-- 5. Join customers with their loans
SELECT c.full_name, l.loan_type, l.principal, l.interest_rate
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id;

-- 6. Find total principal loaned out by loan type
SELECT loan_type, SUM(principal) AS total_principal
FROM Loans
GROUP BY loan_type;

-- 7. Find cities with total principal > 5,000,000
SELECT c.city, SUM(l.principal) AS total_principal
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
GROUP BY c.city
HAVING SUM(l.principal) > 5000000;

-- 8. Categorize loans by principal size
SELECT loan_id, principal,
       CASE
         WHEN principal >= 5000000 THEN 'High Value'
         WHEN principal BETWEEN 1000000 AND 4999999 THEN 'Medium Value'
         ELSE 'Low Value'
       END AS loan_category
FROM Loans;

-- 9. Identify overdue loans (loans with penalties in current year)
SELECT DISTINCT l.loan_id, c.full_name, l.loan_type
FROM Loans l
JOIN Penalties p ON l.loan_id = p.loan_id
JOIN Customers c ON l.customer_id = c.customer_id
WHERE YEAR(p.penalty_date) = 2023;

-- 10. Calculate total interest earned per month (assuming simple interest for demo)
SELECT DATE_FORMAT(r.payment_date, '%Y-%m') AS month,
       SUM(l.principal * (l.interest_rate/100) / 12) AS interest_earned
FROM Repayments r
JOIN Loans l ON r.loan_id = l.loan_id
GROUP BY DATE_FORMAT(r.payment_date, '%Y-%m')
ORDER BY month;

-- 11. Show total interest earned by loan type in last quarter (Apr-Jun 2023)
SELECT l.loan_type,
       SUM(l.principal * (l.interest_rate/100) / 12) AS interest_earned
FROM Repayments r
JOIN Loans l ON r.loan_id = l.loan_id
WHERE r.payment_date BETWEEN '2023-04-01' AND '2023-06-30'
GROUP BY l.loan_type;

-- 12. Customers with loans above average principal
SELECT DISTINCT c.full_name, l.principal
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
WHERE l.principal > (SELECT AVG(principal) FROM Loans);

-- 13. Top 3 highest principal loans using window functions
SELECT loan_id, principal, loan_type,
       RANK() OVER (ORDER BY principal DESC) AS rank_no
FROM Loans
LIMIT 3;

-- 14. Running total of repayments for each loan
SELECT loan_id, payment_date, amount_paid,
       SUM(amount_paid) OVER (PARTITION BY loan_id ORDER BY payment_date) AS running_total
FROM Repayments;

-- 15. Loans with both repayments and penalties
SELECT DISTINCT l.loan_id, c.full_name
FROM Loans l
JOIN Repayments r ON l.loan_id = r.loan_id
JOIN Penalties p ON l.loan_id = p.loan_id;

-- 16. Categorize loans as High, Medium, Low risk based on interest rate
SELECT 
    l.loan_id,
    c.full_name,
    l.interest_rate,
    CASE 
        WHEN l.interest_rate >= 12 THEN 'High Risk'
        WHEN l.interest_rate BETWEEN 8 AND 11.99 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM Loans l
JOIN Customers c ON l.customer_id = c.customer_id;


-- 17. Using a CTE to calculate monthly interest for each loan
WITH MonthlyInterest AS (
    SELECT
        l.loan_id,
        c.full_name,
        l.loan_type,
        ROUND((l.principal * l.interest_rate / 100) / 12, 2) AS monthly_interest
    FROM Loans l
    JOIN Customers c ON l.customer_id = c.customer_id
)
SELECT 
    loan_type,
    SUM(monthly_interest) AS total_monthly_interest
FROM MonthlyInterest
GROUP BY loan_type;


-- 18. Using a subquery to find customers with penalties above the average penalty
SELECT 
    c.full_name,
    SUM(p.penalty_amount) AS total_penalty
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
JOIN Penalties p ON l.loan_id = p.loan_id
GROUP BY c.full_name
HAVING total_penalty > (
    SELECT AVG(total_penalty)
    FROM (
        SELECT SUM(penalty_amount) AS total_penalty
        FROM Penalties
        JOIN Loans ON Penalties.loan_id = Loans.loan_id
        GROUP BY Loans.customer_id
    ) AS sub
);


-- 19. Using a CTE + CASE WHEN to tag overdue loans
WITH LastPayment AS (
    SELECT 
        l.loan_id,
        MAX(r.payment_date) AS last_payment_date
    FROM Loans l
    LEFT JOIN Repayments r ON l.loan_id = r.loan_id
    GROUP BY l.loan_id
)
SELECT
    lp.loan_id,
    CASE 
        WHEN DATEDIFF(CURDATE(), lp.last_payment_date) > 30 THEN 'Overdue'
        ELSE 'On Track'
    END AS payment_status
FROM LastPayment lp;

-- 20.Nested Subquery for High-Value Customers 
SELECT *
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Loans
    GROUP BY customer_id
    HAVING SUM(principal) > 4000000
);

-- 21.CTE + CASE WHEN + Aggregation (Loan Risk Categories) 
WITH LoanRisk AS (
    SELECT 
        loan_id,
        loan_type,
        principal,
        CASE 
            WHEN principal > 4000000 THEN 'High Risk'
            WHEN principal BETWEEN 1000000 AND 4000000 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS risk_level
    FROM Loans
)
SELECT 
    risk_level,
    COUNT(*) AS loan_count,
    SUM(principal) AS total_principal
FROM LoanRisk
GROUP BY risk_level;

-- 22.Window Function for Percent of Total
SELECT 
    c.full_name,
    SUM(l.principal) AS customer_principal,
    ROUND(SUM(l.principal) * 100.0 / SUM(SUM(l.principal)) OVER (), 2) AS pct_of_total
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
GROUP BY c.full_name;


-- 23.PIVOT / Conditional Aggregation (interest earned split into columns by loan type)
SELECT 
    DATE_FORMAT(r.payment_date, '%Y-%m') AS month,
    SUM(CASE WHEN l.loan_type = 'Home Loan' THEN l.principal * (l.interest_rate/100) / 12 ELSE 0 END) AS home_loan_interest,
    SUM(CASE WHEN l.loan_type = 'Car Loan' THEN l.principal * (l.interest_rate/100) / 12 ELSE 0 END) AS car_loan_interest
FROM Repayments r
JOIN Loans l ON r.loan_id = l.loan_id
GROUP BY month
ORDER BY month DESC;

-- 24.Compare each customer’s total loans with the average loan amount in their own city. 
SELECT 
    a.full_name,
    a.city,
    a.total_principal,
    city_avg.avg_principal
FROM (
    SELECT c.customer_id, c.full_name, c.city, SUM(l.principal) AS total_principal
    FROM Customers c
    JOIN Loans l ON c.customer_id = l.customer_id
    GROUP BY c.customer_id, c.full_name, c.city
) a
JOIN (
    SELECT c.city, AVG(l.principal) AS avg_principal
    FROM Customers c
    JOIN Loans l ON c.customer_id = l.customer_id
    GROUP BY c.city
) city_avg
ON a.city = city_avg.city
WHERE a.total_principal > city_avg.avg_principal;

-- 25. Recursive CTE's (Simulate loan balance reduction over time with repayments)
WITH RECURSIVE LoanSchedule AS (
    SELECT 
        loan_id,
        principal AS remaining_balance,
        1 AS month_num
    FROM Loans
    WHERE loan_id = 1  -- pick one loan for example
    UNION ALL
    SELECT
        ls.loan_id,
        ROUND(ls.remaining_balance - (ls.remaining_balance * (l.interest_rate/100) / 12) - 5000, 2), -- assume fixed monthly payment
        month_num + 1
    FROM LoanSchedule ls
    JOIN Loans l ON ls.loan_id = l.loan_id
    WHERE ls.remaining_balance > 0
)
SELECT * FROM LoanSchedule;

-- 26.Find customers who have never incurred a penalty using Anti- Join
SELECT c.full_name
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Loans l
    JOIN Penalties p ON l.loan_id = p.loan_id
    WHERE l.customer_id = c.customer_id
);

