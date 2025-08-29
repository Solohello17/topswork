-- Create (database)
CREATE DATABASE salesdb;
USE salesdb;

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    city VARCHAR(50),
    grade INT,
    salesman_id INT
);

INSERT INTO customer VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3008, 'Julian Green', 'London', 300, 5002),
(3004, 'Fabian Johnson', 'Paris', 300, 5006),
(3009, 'Geoff Cameron', 'Berlin', 100, 5003),
(3003, 'Jozy Altidor', 'Moscow', 200, 5007),
(3001, 'Brad Guzan', 'London', NULL, 5005);

CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(10,2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT
);

INSERT INTO orders VALUES
(70001, 150.50, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.50, '2012-08-17', 3009, 5003),
(70007, 948.50, '2012-09-10', 3005, 5002),
(70005, 2400.60, '2012-07-27', 3007, 5001),
(70008, 5760.00, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.40, '2012-10-10', 3009, 5003),
(70012, 250.45, '2012-06-27', 3008, 5002),
(70011, 75.29, '2012-08-17', 3003, 5007),
(70013, 3045.60, '2012-04-25', 3002, 5000);

CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    commission DECIMAL(4,2)
);

INSERT INTO salesman VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5007, 'Paul Adam', 'Rome', 0.13),
(5003, 'Lauson Hen', 'San Jose', 0.12);

CREATE TABLE emp_details (
    emp_idno INT PRIMARY KEY,
    emp_fname VARCHAR(50),
    emp_lname VARCHAR(50),
    emp_dept INT
);

INSERT INTO emp_details VALUES
(127323, 'Michale', 'Robbin', 57),
(526689, 'Carlos', 'Snares', 63),
(843795, 'Enric', 'Dosio', 57),
(328717, 'Jhon', 'Snares', 63),
(444527, 'Joseph', 'Dosni', 47),
(659831, 'Zanifer', 'Emily', 47),
(847674, 'Kuleswar', 'Sitaraman', 57),
(748681, 'Henrey', 'Gabriel', 47),
(555935, 'Alex', 'Manuel', 57),
(539569, 'George', 'Mardy', 27),
(733843, 'Mario', 'Saule', 63),
(631548, 'Alan', 'Snappy', 27),
(839139, 'Maria', 'Foster', 57);

CREATE TABLE item_mast (
    pro_id INT PRIMARY KEY,
    pro_name VARCHAR(50),
    pro_price DECIMAL(10,2),
    pro_com INT
);

INSERT INTO item_mast VALUES
(101, 'Motherboard', 3200.00, 15),
(102, 'Keyboard', 450.00, 16),
(103, 'ZIP drive', 250.00, 14),
(104, 'Speaker', 550.00, 16),
(105, 'Monitor', 5000.00, 11),
(106, 'DVD drive', 900.00, 12),
(107, 'CD drive', 800.00, 12),
(108, 'Printer', 2600.00, 13),
(109, 'Refill cartridge', 350.00, 13),
(110, 'Mouse', 250.00, 12);

-- Q!. write a SQL query to find customers who are either from the city 'NewYork' or who do not have a grade greater than 100. Return customer_id, cust_name, city, grade, and salesman_id.
SELECT customer_id, cust_name, city, grade, salesman_id
FROM customer
WHERE city = 'New York'
   OR grade <= 100
   OR grade IS NULL;
   
-- Q2. write a SQL query to find all the customers in ‘New York’ city who have agradevalue above 100. Return customer_id, cust_name, city, grade, and salesman_id.

SELECT customer_id, cust_name, city, grade, salesman_id
FROM customer
WHERE city = 'New York'
  AND grade > 100;
  
-- Q3. 3. Write a SQL query that displays order number, purchase amount, and the achieved and unachieved percentage (%) for those orders that exceed 50%of thetarget value of 6000

SELECT 
    ord_no,
    purch_amt,
    ROUND((purch_amt / 6000) * 100, 2) AS achieved_percentage,
    ROUND(100 - ((purch_amt / 6000) * 100), 2) AS unachieved_percentage
FROM orders
WHERE purch_amt > 6000 * 0.5;

-- Q4. write a SQL query to calculate the total purchase amount of all orders. Returntotal purchase amount
SELECT SUM(purch_amt) AS total_purchase_amount
FROM orders;

-- Q5. write a SQL query to find the highest purchase amount ordered by each customer. Return customer ID, maximum purchase amount.

SELECT customer_id, 
       MAX(purch_amt) AS max_purchase_amount
FROM orders
GROUP BY customer_id;

-- Q6. write a SQL query to calculate the average product price. Return average product price.
SELECT AVG(pro_price) AS average_product_price
FROM item_mast;

-- Q7. write a SQL query to find those employees whose department is located at ‘Toronto’. Return first name, last name, employee ID, job ID.

SELECT e.first_name, 
       e.last_name, 
       e.employee_id, 
       e.job_id
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE l.city = 'Toronto';

-- Q8. write a SQL query to find those employees whose salary is lower than that of employees whose job title is "MK_MAN". Exclude employees of the Jobtitle‘MK_MAN’. Return employee ID, first name, last name, job ID.

SELECT e.employee_id, 
       e.first_name, 
       e.last_name, 
       e.job_id
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
WHERE e.salary < (SELECT MIN(salary) 
                  FROM employees em 
                  JOIN jobs jb ON em.job_id = jb.job_id
                  WHERE jb.job_title = 'Marketing Manager')
  AND j.job_title <> 'Marketing Manager';
  
-- Q9. write a SQL query to find all those employees who work in department ID80or40. Return first name, last name, department number and department name. 

SELECT e.first_name, 
       e.last_name, 
       e.department_id, 
       d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.department_id IN (80, 40);

-- Q10.write a SQL query to calculate the average salary, the number of employees receiving commissions in that department. Return department name, averagesalary and number of employees

SELECT d.department_name,
       ROUND(AVG(e.salary), 2) AS average_salary,
       COUNT(CASE WHEN e.commission_pct IS NOT NULL THEN 1 END) AS num_with_commission
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- Q11. write a SQL query to find out which employees have the same designationas theemployee whose ID is 169. Return first name, last name, department IDandjobID

SELECT e.first_name, 
       e.last_name, 
       e.department_id, 
       e.job_id
FROM employees e
WHERE e.job_id = (
    SELECT job_id 
    FROM employees 
    WHERE employee_id = 169
);

-- Q12. Find employees who earn more than the average salary

SELECT employee_id, first_name, last_name
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Q13.Find all employees who work in the Finance department

SELECT e.department_id, e.first_name, e.last_name, e.job_id, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';

-- Q14. find employees who earn less than employee with ID = 182

SELECT first_name, last_name, salary
FROM employees
WHERE salary < (SELECT salary FROM employees WHERE employee_id = 182);

-- Q15. Create a stored procedure CountEmployeesByDept that returns the number of employees in each department
DELIMITER $$

CREATE PROCEDURE CountEmployeesByDept()
BEGIN
    SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS total_employees
    FROM departments d
    LEFT JOIN employees e ON d.department_id = e.department_id
    GROUP BY d.department_id, d.department_name;
END $$

DELIMITER ;

-- Q16. Create a stored procedure AddNewEmployee that adds a new employee tothedatabase.
DELIMITER $$

CREATE PROCEDURE AddNewEmployee(
    IN p_emp_id INT,
    IN p_first_name VARCHAR(20),
    IN p_last_name VARCHAR(25),
    IN p_email VARCHAR(25),
    IN p_phone VARCHAR(20),
    IN p_hire_date DATE,
    IN p_job_id VARCHAR(10),
    IN p_salary DECIMAL(8,2),
    IN p_commission DECIMAL(2,2),
    IN p_manager_id INT,
    IN p_dept_id INT
)
BEGIN
    INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
    VALUES (p_emp_id, p_first_name, p_last_name, p_email, p_phone, p_hire_date, p_job_id, p_salary, p_commission, p_manager_id, p_dept_id);
END $$

DELIMITER ;

-- Q17. Create a stored procedure DeleteEmployeesByDept that removes all employeesfrom a specific department

DELIMITER $$

CREATE PROCEDURE DeleteEmployeesByDept(IN p_dept_id INT)
BEGIN
    DELETE FROM employees WHERE department_id = p_dept_id;
END $$

DELIMITER ;


-- Q!8. Create a stored procedure GetTopPaidEmployees that retrieves the highest-paidemployee in each department.

DELIMITER $$

CREATE PROCEDURE GetTopPaidEmployees()
BEGIN
    SELECT e.department_id, d.department_name, e.first_name, e.last_name, e.salary
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    WHERE e.salary = (
        SELECT MAX(salary)
        FROM employees
        WHERE department_id = e.department_id
    );
END $$

DELIMITER ;

-- Q19. Create a stored procedure PromoteEmployee that increases an employee’s salaryand changes their job role

DELIMITER $$

CREATE PROCEDURE PromoteEmployee(
    IN p_emp_id INT,
    IN p_new_job_id VARCHAR(10),
    IN p_salary_increase DECIMAL(8,2)
)
BEGIN
    UPDATE employees
    SET job_id = p_new_job_id,
        salary = salary + p_salary_increase
    WHERE employee_id = p_emp_id;
END $$

DELIMITER ;

-- Q20. Create a stored procedure AssignManagerToDepartment that assigns a newmanager to all employees in a specific department

DELIMITER $$

CREATE PROCEDURE AssignManagerToDepartment(
    IN p_dept_id INT,
    IN p_new_manager_id INT
)
BEGIN
    UPDATE employees
    SET manager_id = p_new_manager_id
    WHERE department_id = p_dept_id;
END $$

DELIMITER ;







