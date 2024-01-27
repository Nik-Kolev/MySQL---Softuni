-- 1.	Employees with Salary Above 35000
delimiter $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
SELECT
	first_name,
	last_name
FROM
	employees e
WHERE
	salary > 35000
ORDER BY
	first_name,
	last_name,
	employee_id;
END $$
delimiter ;

CALL usp_get_employees_salary_above_35000();

-- 2.	Employees with Salary Above Number
delimiter $$
CREATE PROCEDURE usp_get_employees_salary_above(treshhold DOUBLE(19,4))
BEGIN 
	SELECT first_name, last_name FROM employees e 
	WHERE salary >= treshhold
	ORDER BY first_name, last_name, employee_id;
END $$
delimiter ;

CALL usp_get_employees_salary_above(45000);

-- 3.	Town Names Starting With
delimiter $$
CREATE PROCEDURE usp_get_towns_starting_with(starts_with varchar(50))
BEGIN	
	SELECT name FROM towns t
	WHERE left(name, LENGTH(starts_with)) = starts_with
	ORDER BY name;
END $$
delimiter ;

CALL usp_get_towns_starting_with ('be');

-- 4.	Employees from Town
delimiter $$
CREATE PROCEDURE usp_get_employees_from_town(town_name varchar(50))
BEGIN	
	SELECT e.first_name, e.last_name  FROM towns t 
	JOIN addresses a ON a.town_id = t.town_id 
	JOIN employees e ON e.address_id = a.address_id 
	WHERE t.name = town_name
	ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
delimiter ;

CALL usp_get_employees_from_town('Sofia');

-- 5.	Salary Level Function
delimiter $$
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(19,4))
RETURNS varchar (7)
RETURN (
	CASE 
		WHEN salary < 30000 THEN 'Low'
		WHEN salary <= 50000 THEN 'Average'
		ELSE 'High'
	END
);
delimiter ;

SELECT ufn_get_salary_level(44440);

-- 6.	Employees by Salary Level
delimiter $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_param varchar(7))
BEGIN
	SELECT first_name, last_name  FROM employees e 
	WHERE salary_param = 'High' AND  salary > 50000 OR 
			 salary_param = 'Low' AND  salary < 30000 OR 
			 salary_param = 'Average' AND  salary >= 30000 AND salary <= 50000
	ORDER BY first_name DESC , last_name DESC;
END	$$
delimiter ;
	
CALL usp_get_employees_by_salary_level('high');

-- 7.	Define Function
delimiter $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS int
RETURN word REGEXP (CONCAT('^[', set_of_letters, ']+$'));
delimiter ;

SELECT ufn_is_word_comprised('Nik', 'Niko');
	
-- 8.	Find Full Name
delimiter $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN	
	SELECT concat(first_name, ' ', last_name) AS full_name FROM account_holders ah 
	ORDER BY full_name, id;
END $$

delimiter ;

CALL usp_get_holders_full_name();


