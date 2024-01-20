-- 1.	Find Names of All Employees by First Name
SELECT FIRST_name, last_name FROM employees e 
WHERE FIRST_name LIKE 'Sa%'
ORDER BY employee_id;

-- 2.	Find Names of All Employees by Last Name
SELECT first_name, last_name FROM employees e 
WHERE last_name LIKE '%ei%'
ORDER BY employee_id ;

-- 3.	Find First Names of All Employees
SELECT first_name FROM employees e 
WHERE   department_id IN (3, 10) and YEAR (hire_date) BETWEEN 1995 AND 2005
ORDER BY employee_id ;


-- 4.	Find All Employees Except Engineers
SELECT first_name, last_name FROM employees e 
WHERE job_title REGEXP '(engineer)' = 0
ORDER BY employee_id ;

-- 5.	Find Towns with Name Length
SELECT name FROM towns t  
WHERE char_length(name) BETWEEN 5 AND 6
ORDER BY name ; 

-- 6.	Find Towns Starting With
SELECT * FROM towns t 
WHERE name REGEXP '^[M|K|B|E]'
ORDER BY name ;

-- 7.	Find Towns Not Starting With
SELECT * FROM towns t 
WHERE name REGEXP '^[R|B|D]' = 0
ORDER BY name ;

-- 8.	Create View Employees Hired After 2000 Year
CREATE VIEW	v_employees_hired_after_2000 AS
SELECT first_name, last_name FROM employees e 
WHERE YEAR (hire_date) > 2000; -- OR BETWEEN 2001 AND NOW()
SELECT * FROM  v_employees_hired_after_2000;

-- 9.	Length of Last Name
SELECT first_name, last_name FROM employees e 
WHERE char_length(last_name) = 5; 

-- 10.	Countries Holding 'A' 3 or More Times
SELECT country_name , iso_code  FROM countries c 
WHERE country_name  LIKE '%a%a%a%' -- WITH regex WHERE country_name REGEXP '.*a.{3}';
ORDER BY iso_code ;

-- 11.	Mix of Peak and River Names

-- 12.	Games from 2011 and 2012 Year
SELECT name, date_format(`start`, '%Y-%m-%d') AS start  FROM games g 
WHERE YEAR (`start`) BETWEEN 2011 AND 2012
ORDER BY date_format(`start`, '%Y-%m-%d'), name,
LIMIT 50;

-- 13.	User Email Providers
SELECT user_name, SUBSTRING(email FROM LOCATE('@', email) + 1) AS 'email provider' FROM users u 
ORDER BY SUBSTRING(email FROM LOCATE('@', email) + 1), user_name;

-- 14.  Get Users with IP Address Like Pattern
SELECT  user_name, ip_address  FROM users u 
WHERE ip_address LIKE '___.1%.%.___'
ORDER BY user_name 

-- 15.	Show All Games with Duration and Part of the Day

-- 16.	Orders Table
