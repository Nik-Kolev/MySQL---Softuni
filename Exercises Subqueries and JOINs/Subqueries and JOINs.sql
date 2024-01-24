-- 1.	Employee Address
SELECT employee_id, job_title, a.address_id, a.address_text FROM employees e 
JOIN addresses a ON e.address_id = a.address_id
ORDER BY a.address_id 
LIMIT 5;

-- 2.	Addresses with Towns
SELECT first_name, last_name, t.name, address_text FROM employees e 
JOIN addresses a ON a.address_id = e.address_id 
JOIN towns t ON a.town_id = t.town_id
ORDER BY first_name, last_name
LIMIT 5;

-- 3.	Sales Employee
SELECT employee_id, first_name, last_name, d.name FROM employees e
JOIN departments d ON e.department_id = d.department_id 
WHERE d.name = 'Sales'
ORDER BY employee_id DESC;

-- 4.	Employee Departments
SELECT employee_id, first_name, salary, d.name FROM employees e 
JOIN departments d ON e.department_id = d.department_id
WHERE salary > 15000
ORDER BY d.department_id DESC 
LIMIT 5;

-- 5.	Employees Without Project
SELECT e.employee_id, first_name  FROM employees e
WHERE e.employee_id NOT IN (SELECT ep.employee_id FROM employees_projects ep)
ORDER BY e.employee_id DESC
LIMIT 3;

-- 6.	Employees Hired After
SELECT first_name, last_name, hire_date, d.name AS 'dept_name' FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
WHERE hire_date > 1999-1-1 AND d.name IN ('Sales', 'Finance')
ORDER BY hire_date;

-- 7.	Employees with Project
SELECT
	e.employee_id,
	e.first_name,
	p.name AS project_name
FROM
	employees e
JOIN employees_projects ep ON
	e.employee_id = ep.employee_id
JOIN projects p ON
	p.project_id = ep.project_id
WHERE
	DATE(p.start_date) > '2002-08-13'
	AND p.end_date IS NULL
ORDER BY
	first_name,
	project_name
LIMIT 5;

-- 8.	Employee 24
SELECT
	e.employee_id,
	first_name,
	IF (YEAR (p.start_date) >= 2005, NULL, p.name) AS project_name
FROM
	employees e
JOIN employees_projects ep ON
	e.employee_id = ep.employee_id
JOIN projects p ON
	p.project_id = ep.project_id
WHERE
	e.employee_id = 24
ORDER BY
	p.name;

-- 9.	Employee Manager
SELECT e.employee_id, e.first_name, e.manager_id, e2.first_name AS manager_name FROM employees e
JOIN employees e2 ON e.manager_id = e2.employee_id
WHERE e.manager_id IN (3, 7)
ORDER BY e.first_name;

-- 10.	Employee Summary
SELECT
	e.employee_id,
	concat(e.first_name, ' ', e.last_name) AS employee_name,
	concat(e2.first_name, ' ', e2.last_name) AS manager_name,
	d.name AS department_name
FROM employees e 
JOIN employees e2 ON e.manager_id = e2.employee_id 
JOIN departments d ON e.department_id = d.department_id 
ORDER BY e.employee_id
LIMIT 5;

-- 11.	Min Average Salary
SELECT AVG(salary) AS min_average_salary FROM employees e 
GROUP BY e.department_id 
ORDER BY min_average_salary
LIMIT 1;