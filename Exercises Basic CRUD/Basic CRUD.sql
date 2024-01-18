-- 1. Find All Information About Departments 
SELECT * FROM departments d 
ORDER BY department_id ;

-- 2. Find all Department Names 
SELECT name FROM departments d 
ORDER BY department_id;

-- 3. Find salary of Each Employee 
SELECT first_name, last_name, salary FROM	employees e 
ORDER BY employee_id ;

-- 4. Find Full Name of Each Employee 
SELECT first_name, middle_name, last_name FROM employees e 
ORDER BY employee_id ;

-- 5. Find Email Address of Each Employee 
SELECT concat (first_name,'.',last_name,'@softuni.bg') AS 'full_email_address' FROM employees e ;

-- 6. Find All Different Employee's Salaries 
SELECT DISTINCT salary FROM employees e ;

-- 7. Find all Information About Employees
SELECT * FROM employees e 
WHERE job_title = 'Sales Representative'
ORDER  BY employee_id ;

-- 8. Find Names of All Employees by salary in Range 
SELECT first_name, last_name, job_title  FROM employees e 
WHERE salary >= 20000 AND salary <= 30000
// WHERE salary BETWEEN 20000 AND 30000 -- IS better AS it IS MORE readable. 
ORDER BY employee_id ; 

-- 9.  Find Names of All Employees  
SELECT concat_ws(' ',first_name, middle_name, last_name) AS 'Full Name' FROM employees e 
WHERE  salary = 25000 OR salary = 14000 OR salary = 12500 OR salary = 23600;
// WHERE salary IN (25000, 14000, 12500, 23600) -- IS better.

-- 10. Find All Employees Without Manager 
SELECT first_name, last_name FROM employees e 
WHERE manager_id IS NULL ;

-- 11. Find All Employees with salary More Than 50000 
SELECT first_name, last_name, salary FROM	employees e 
WHERE salary > 50000
ORDER BY salary DESC;

-- 12. Find 5 Best Paid Employees 
SELECT first_name, last_name FROM employees e 
ORDER BY salary  DESC 
LIMIT 5;

-- 13. Find All Employees Except Marketing 
SELECT first_name, last_name FROM employees e 
WHERE department_id != 4;

-- 14. Sort Employees Table 
SELECT * FROM employees e 
ORDER BY salary DESC, first_name , last_name DESC, middle_name;

-- 15. Create View Employees with Salaries 
CREATE	VIEW v_employees_salaries as
SELECT first_name, last_name, salary FROM employees e ;

-- 16. Create View Employees with Job Titles 
CREATE VIEW v_employees_job_titles AS
SELECT concat_ws(' ', first_name, middle_name, last_name) AS 'full_name', job_title FROM employees e ; -- IF middle_name IS NULL it will REPLACE it WITH SPACE 

-- 17.  Distinct Job Titles 
SELECT DISTINCT job_title FROM	 employees e 
ORDER BY job_title ;

-- 18. Find First 10 Started Projects 
SELECT project_id , name, description, start_date, end_date FROM projects p 
ORDER BY start_date , name
LIMIT 10;

-- 19.  Last 7 Hired Employees 
SELECT first_name, last_name, hire_date FROM employees e 
ORDER BY hire_date DESC 
LIMIT 7;

-- 20. Increase Salaries 
UPDATE employees AS e
SET salary = salary * 1.12
WHERE  department_id IN (1,2,4,11);
SELECT salary FROM employees e ;

-- Better solution:
-- UPDATE employees
-- SET salary = salary * 1.12
-- WHEN department_id IN (SELECT department_id FROM departments WHERE name IN ('Engineering', 'Tool Design', 'Marketing', 'Information Services')
-- SELECT salary  FROM employees ;

-- 21. All Mountain Peaks 
SELECT peak_name FROM peaks p 
ORDER BY peak_name ;

-- 22.  Biggest Countries by Population 
SELECT country_name, population FROM	countries c 
WHERE continent_code = 'EU'
ORDER BY population DESC , country_name
LIMIT 30;

-- 23.  Countries and Currency (Euro / Not Euro) 
SELECT country_name, country_code, IF (currency_code = 'EUR', 'Euro', 'Not Euro') AS 'currency' FROM	countries c
ORDER	BY country_name;

-- 24.  All Diablo Characters 
SELECT name FROM `characters` c 
ORDER	BY name;

