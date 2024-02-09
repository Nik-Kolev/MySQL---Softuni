CREATE DATABASE gamedev;
USE gamedev;

-- 01 Table Design
CREATE TABLE addresses(
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(50) NOT NULL 
);

CREATE TABLE categories(
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(10) NOT NULL
);

CREATE TABLE offices(
	id int PRIMARY KEY AUTO_INCREMENT,
	workspace_capacity int NOT NULL,
	website varchar(50),
	address_id int NOT NULL,
	CONSTRAINT fk_offices_address
	FOREIGN KEY (address_id) REFERENCES addresses(id)
);

CREATE TABLE employees(
	id int PRIMARY KEY AUTO_INCREMENT,
	first_name varchar(30) NOT NULL,
	last_name varchar(30) NOT NULL,
	age int NOT NULL,
	salary decimal(10,2) NOT NULL,
	job_title varchar(20) NOT NULL,
	happiness_level char(1) NOT NULL
);

CREATE TABLE teams(
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(40) NOT NULL,
	office_id int NOT NULL,
	CONSTRAINT fk_teams_offices
	FOREIGN KEY (office_id) REFERENCES offices(id),
	leader_id int NOT NULL UNIQUE,
	CONSTRAINT fk_teams_employees
	FOREIGN KEY (leader_id) REFERENCES employees(id)
);

CREATE TABLE games(
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(50) NOT NULL UNIQUE,
	description text,
	rating float NOT NULL DEFAULT 5.5,
	budget decimal(10,2) NOT NULL,
	release_date date,
	team_id int NOT NULL,
	CONSTRAINT fk_games_teams
	FOREIGN KEY (team_id) REFERENCES teams(id)
);

CREATE TABLE games_categories(
	game_id int NOT NULL,
	category_id int NOT NULL,
	PRIMARY KEY(game_id, category_id),
	CONSTRAINT fk_games_categories_game
	FOREIGN key(game_id) REFERENCES games(id),
	CONSTRAINT fk_games_categories_category
	FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- 02 Insert
INSERT INTO games(name, rating, budget, team_id)
(SELECT
	(reverse(lower(RIGHT(name, LENGTH(name)-1)))) AS name,
	t.id AS raiting,
	t.leader_id*1000 AS budget,
	t.id
FROM
	teams t 
WHERE t.id BETWEEN 1 AND 9);

-- 03 Update
UPDATE employees e
JOIN teams t ON e.id = t.leader_id 
SET e.salary = e.salary + 1000
WHERE e.age < 40 AND e.salary < 5000

-- 04 Delete
DELETE g FROM games g
LEFT JOIN games_categories gc ON g.id = gc.game_id 
WHERE release_date IS NULL AND gc.category_id IS NULL;

-- 5.	Employees
SELECT first_name, last_name, age, salary, happiness_level FROM employees e 
ORDER BY salary, id;

-- 6.	Addresses of the teams
SELECT t.name, a.name, LENGTH(a.name) FROM teams t 
JOIN offices o ON t.office_id = o.id 
JOIN addresses a ON o.address_id = a.id
WHERE o.website IS NOT NULL
ORDER BY t.name, a.name;

-- 7.	Categories Info
SELECT c.name, count(c.id), round(avg(g.budget),2), max(g.rating) FROM games g 
JOIN games_categories gc ON g.id = gc.game_id 
JOIN categories c ON gc.category_id = c.id 
GROUP BY c.name 
HAVING max(g.rating) >= 9.5
ORDER BY count(c.id) DESC, c.name;

-- 8.	Games of 2022
SELECT
	g.name,
	g.release_date,
	concat(LEFT(g.description, 10), '...'),
	(CASE
		WHEN month(g.release_date) IN (1,2,3) THEN 'Q1'
		WHEN month(g.release_date) IN (4,5,6) THEN 'Q2'
		WHEN month(g.release_date) IN (7,8,9) THEN 'Q3'
		ELSE 'Q4'
	END
	) AS quarter,
	t.name
FROM
	games g
JOIN teams t ON
	g.team_id = t.id
WHERE
	RIGHT(g.name,
	1) = '2' AND MONTH(g.release_date) IN (2,4,6,8,10,12) AND YEAR(g.release_date) = '2022'
ORDER BY quarter;
	

-- 9.	Full info for games
SELECT
	g.name,
	(CASE 
		WHEN g.budget < 50000 THEN 'Normal budget'
		ELSE 'Insufficient budget'
	END
	) AS budget,
	t.name,
	a.name
FROM
	games g
JOIN teams t ON
	g.team_id = t.id
LEFT JOIN games_categories gc ON
	g.id = gc.game_id
JOIN offices o ON
	t.office_id = o.id
JOIN addresses a ON
	o.address_id = a.id
WHERE
	g.release_date IS NULL
	AND gc.category_id IS NULL
ORDER BY g.name

-- 10.	Find all basic information for a game
delimiter $$
CREATE FUNCTION udf_game_info_by_name(game_name varchar(20))
RETURNS text
BEGIN	
		DECLARE temp1 varchar(20);
		DECLARE temp2 varchar(20);
		DECLARE temp3 varchar(20);
		
		SELECT g.name, t.name, a.name 
		INTO temp1, temp2, temp3
		FROM games g 
		JOIN teams t ON g.team_id = t.id 
		JOIN offices o ON t.office_id = o.id 
		JOIN addresses a ON o.address_id = a.id 
		WHERE g.name = game_name;
		RETURN concat('The ', temp1, ' is developed by a ', temp2, ' in an office with an address ', temp3);
END $$
delimiter ;


-- 11.	Update the budget of the games 
delimiter $$
CREATE PROCEDURE udp_update_budget(min_game_rating float)
BEGIN	
	UPDATE games g
	LEFT JOIN games_categories gc ON g.id = gc.game_id 
	SET g.budget = g.budget + 100000, g.release_date = date_add(g.release_date, INTERVAL 1 year)
	WHERE gc.category_id IS NULL AND g.rating > min_game_rating AND g.release_date IS NOT NULL;
END $$
delimiter ;

SELECT * FROM games g 
LEFT JOIN games_categories gc ON g.id = gc.game_id 
WHERE gc.category_id IS NULL AND g.rating > 8 AND g.release_date IS NOT NULL
