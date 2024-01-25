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

-- 12.	Highest Peaks in Bulgaria
SELECT c.country_code, m.mountain_range, p.peak_name, p.elevation  FROM countries c 
JOIN mountains_countries mc ON mc.country_code = c.country_code
JOIN mountains m ON  mc.mountain_id = m.id
JOIN peaks p ON mc.mountain_id = p.mountain_id  
WHERE c.country_code = 'BG' AND p.elevation > 2835
ORDER BY p.elevation desc;

-- 13.	Count Mountain Ranges
SELECT c.country_code, COUNT(m.mountain_range) AS mountain_range  FROM countries c 
JOIN mountains_countries mc ON mc.country_code = c.country_code 
JOIN mountains m ON m.id = mc.mountain_id 
WHERE c.country_name IN ('United States', 'Russia', 'Bulgaria')
GROUP BY c.country_code 
ORDER BY mountain_range DESC;
 
-- 14.	Countries with Rivers
SELECT c.country_name, r.river_name  FROM countries c 
LEFT JOIN countries_rivers cr ON c.country_code = cr.country_code 
LEFT JOIN rivers r ON cr.river_id = r.id 
WHERE c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;

-- 15.	*Continents and Currencies
SELECT
	c.continent_code,
	c.currency_code,
	COUNT(*) AS currency_usage
FROM
	countries c
GROUP BY
	c.continent_code,
	c.currency_code
HAVING
	currency_usage > 1
	AND currency_usage = (
	SELECT
		COUNT(*) AS count_of_currencies
	FROM
		countries c2
	WHERE
		c2.continent_code = c.continent_code
		GROUP BY c2.currency_code
		ORDER BY count_of_currencies desc
		LIMIT 1)
ORDER BY
	c.continent_code,
	c.currency_code;


-- 16.  Countries Without Any Mountains

-- 17.  Highest Peak and Longest River by Country
