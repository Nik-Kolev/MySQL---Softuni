CREATE DATABASE wildlife;
USE wildlife;

-- 01 Table Design
CREATE TABLE continents(
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(40) NOT NULL UNIQUE
);

CREATE TABLE countries(
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(40) NOT NULL UNIQUE,
	country_code varchar(10) NOT NULL UNIQUE,
	continent_id int NOT NULL,
	CONSTRAINT fk_countries_continents
	FOREIGN KEY (continent_id) REFERENCES continents(id)
);

CREATE TABLE preserves(
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(255) NOT NULL UNIQUE,
	latitude decimal(9,6),
	longitude decimal(9,6),
	area int,
	`type` varchar(20),
	established_on date
);

CREATE TABLE positions(
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(40) NOT NULL UNIQUE,
	description text,
	is_dangerous tinyint(1) NOT NULL
);

CREATE TABLE workers(
	id int PRIMARY KEY AUTO_INCREMENT,
	first_name varchar(40) NOT NULL,
	last_name varchar(40) NOT NULL,
	age int,
	personal_number varchar(20) NOT NULL UNIQUE,
	salary decimal(19,2),
	is_armed tinyint(1) NOT NULL,
	start_date date,
	preserve_id int,
	CONSTRAINT fk_workers_preservers
	FOREIGN KEY (preserve_id) REFERENCES preserves(id),
	position_id int,
	CONSTRAINT fk_workers_positions
	FOREIGN KEY (position_id) REFERENCES positions(id)
);

CREATE TABLE countries_preserves(
	country_id int,
	preserve_id int,
	CONSTRAINT fk_countries_preserves_countries
	FOREIGN KEY (country_id) REFERENCES countries(id),
	CONSTRAINT fk_countries_preserves_preserve
	FOREIGN KEY (preserve_id) REFERENCES preserves(id)
);

-- 02 Insert
INSERT INTO preserves(name, latitude, longitude, area, `type`, established_on)
(SELECT
	concat(name, " ", 'is in South Hemisphere'),
	latitude,
	longitude,
	area*id AS area,
	lower(`type`), 
	established_on 
FROM
	preserves p 
WHERE latitude < 0);
SELECT
	concat(name, " ", 'is in South Hemisphere'),
	latitude,
	longitude,
	area*id AS area,
	'preserve type' AS `type` ,
	established_on 
FROM
	preserves p 
WHERE latitude < 0;

-- 03 Update
UPDATE workers 
SET salary = salary + 500
WHERE position_id IN (5,8,11,13);

-- 04 Delete
DELETE FROM preserves 
WHERE established_on IS NULL 

-- 05.	Most experienced workers
SELECT
	concat(first_name, ' ', last_name) AS full_name,
	datediff('2024-01-01', start_date) AS days_of_experience
FROM
	workers w
WHERE
	'2024-01-01' - YEAR(start_date) > 5
ORDER BY days_of_experience DESC
LIMIT 10;

-- 06.	Worker's salary
SELECT w.id, w.first_name, w.last_name, p.name, c.country_code  FROM workers w 
JOIN preserves p ON w.preserve_id = p.id 
JOIN countries_preserves cp ON p.id = cp.preserve_id 
JOIN countries c ON cp.country_id = c.id
WHERE w.salary > 5000 AND w.age < 50
ORDER BY c.country_code;

-- 07.	Armed workers count
SELECT p.name, count(*) AS armed_workers FROM workers w 
JOIN preserves p ON w.preserve_id = p.id 
WHERE w.is_armed IS TRUE 
GROUP BY p.id 
ORDER BY armed_workers DESC, p.name;

-- 08.	Oldest preserves
SELECT p.name, c.country_code, year(p.established_on) FROM preserves p 
JOIN countries_preserves cp ON p.id = cp.preserve_id 
JOIN countries c ON cp.country_id = c.id 
WHERE month(p.established_on) = 5
ORDER BY p.established_on
LIMIT 5;

-- 09.	Preserve categories
SELECT
	id,
	name,
	(CASE
		WHEN area <= 100 THEN 'very small'
		WHEN area BETWEEN 101 AND 1000 THEN 'small'
		WHEN area BETWEEN 1001 AND 10000 THEN 'medium'
		WHEN area BETWEEN 10001 AND 50000 THEN 'large'
		ELSE 'very large'
	END) AS category
FROM
	preserves p 
ORDER BY area DESC 

-- 10.	Extract average salary
delimiter $$
CREATE FUNCTION udf_average_salary_by_position_name(name varchar(40))
RETURNS decimal(19,2)
	RETURN (SELECT avg(w.salary) FROM workers w 
	JOIN positions p ON w.position_id = p.id 
	WHERE p.name = name
	GROUP BY p.name);
delimiter ;

-- 11.	Improving the standard of living
delimiter $$
CREATE PROCEDURE udp_increase_salaries_by_country(country_name varchar(40))
BEGIN
    UPDATE workers w
    JOIN preserves p ON w.preserve_id = p.id
    JOIN countries_preserves cp ON p.id = cp.preserve_id
    JOIN countries c ON cp.country_id = c.id
    SET w.salary = w.salary * 1.05
    WHERE c.name = country_name;
END $$
delimiter ;
