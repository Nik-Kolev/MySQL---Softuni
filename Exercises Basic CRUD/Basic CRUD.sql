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
ORDER BY employee_id ; 

-- 9.  Find Names of All Employees  
SELECT concat_ws(' ',first_name, middle_name, last_name) AS 'Full Name' FROM employees e 
WHERE  salary = 25000 OR salary = 14000 OR salary = 12500 OR salary = 23600;

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