CREATE DATABASE universities;
USE universities;
-- 01.	Table Design
CREATE TABLE countries (
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(40) NOT NULL UNIQUE
);

CREATE TABLE cities (
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(40) NOT NULL UNIQUE,
	population int,
	country_id int NOT NULL,
	CONSTRAINT fk_cities_countries
	FOREIGN KEY (country_id) REFERENCES cities(id)
);

CREATE TABLE universities (
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(60) NOT NULL UNIQUE,
	address varchar(80) NOT NULL UNIQUE,
	tuition_fee decimal(19,2) NOT NULL,
	number_of_staff int,
	city_id int,
	CONSTRAINT fk_universities_cities
	FOREIGN KEY(city_id) REFERENCES cities(id)
);

CREATE TABLE students (
	id int PRIMARY KEY AUTO_INCREMENT,
	first_name varchar(40) NOT NULL,
	last_name varchar(40) NOT NULL,
	age int,
	phone varchar(20) NOT NULL UNIQUE,
	email varchar(255) NOT NULL UNIQUE,
	is_graduated tinyint(1) NOT NULL,
	city_id int,
	CONSTRAINT fk_students_cities
	FOREIGN KEY (city_id) REFERENCES cities(id)
);

CREATE TABLE courses (
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(40) NOT NULL UNIQUE,
	duration_hours decimal(19,2),
	start_date date,
	teacher_name varchar(60) NOT NULL UNIQUE,
	description text,
	university_id int,
	CONSTRAINT fk_courses_universities
	FOREIGN KEY (university_id) REFERENCES universities(id)
);

CREATE TABLE students_courses (
	grade decimal(19,2) NOT NULL,
	student_id int,
	course_id int,
	CONSTRAINT fk_students_courses_student
	FOREIGN KEY (student_id) REFERENCES students(id),
	CONSTRAINT fk_students_courses_course
	FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- 02. Insert
INSERT INTO courses(name, duration_hours, start_date, teacher_name, description, university_id)
(SELECT
	concat_ws(' ', teacher_name, 'course') AS name,
	LENGTH(name)/10 AS duration_hours,
	date_add(start_date, INTERVAL 5 day),
	reverse(teacher_name) AS teacher_name,
	concat('Course ', teacher_name, reverse(description)) AS description,
	day(start_date)
FROM
	courses c
WHERE
	c.id <= 5);

  
-- 03. Update
UPDATE universities 
SET tuition_fee = tuition_fee + 300
WHERE id BETWEEN 5 AND 12;

-- 04. Delete
DELETE FROM universities 
WHERE number_of_staff IS NULL;

-- 05.	Cities
SELECT * FROM cities c 
ORDER BY population DESC

-- 06.	Students age
SELECT first_name, last_name, age, phone, email  FROM students s 
WHERE age >= 21
ORDER BY first_name DESC, email, id
LIMIT 10

-- 07.	New students
SELECT
	concat(first_name, ' ', last_name) AS full_name,
	substr(email, 2, 10) AS username,
	reverse(phone) AS password
FROM
	students s
LEFT JOIN students_courses sc ON
	s.id = sc.student_id
WHERE
	sc.course_id IS NULL
ORDER BY password DESC;

-- 08.	Students count
SELECT count(*) AS students_count, u.name AS university_name  FROM students s
JOIN students_courses sc ON s.id = sc.student_id 
JOIN courses c ON sc.course_id = c.id 
JOIN universities u ON c.university_id = u.id
GROUP BY u.name
HAVING students_count >= 8
ORDER BY students_count DESC, university_name DESC;

-- 09.	Price rankings
SELECT
	u.name AS university_name,
	c.name AS city_name,
	u.address AS address,
	(CASE 
		WHEN u.tuition_fee < 800 THEN 'cheap'
		WHEN u.tuition_fee BETWEEN 800 AND 1199 THEN 'normal'
		WHEN u.tuition_fee BETWEEN 1200 AND 2499 THEN 'high'
		WHEN u.tuition_fee > 2500 THEN 'expensive'
	END) AS price_rank,
	u.tuition_fee
FROM
	universities u
JOIN cities c ON
	u.city_id = c.id
ORDER BY u.tuition_fee;

-- 10.	Average grades
delimiter $$
CREATE FUNCTION udf_average_alumni_grade_by_course_name(course_name varchar(60))
RETURNS decimal(19,2)
RETURN 
	(SELECT AVG(sc.grade) AS average_alumni_grade FROM students_courses sc
	JOIN courses c ON sc.course_id = c.id
	JOIN students s ON sc.student_id = s.id 
	WHERE c.name = course_name AND s.is_graduated IS TRUE
	GROUP BY sc.course_id)
delimiter ;

SELECT AVG(sc.grade) AS average_alumni_grade, c.name FROM students_courses sc
	JOIN courses c ON sc.course_id = c.id
	JOIN students s ON sc.student_id = s.id 
	WHERE c.name = 'Quantum Physics' AND s.is_graduated IS TRUE
	GROUP BY sc.course_id;

-- 11.	Special Offer

delimiter $$
CREATE PROCEDURE udp_graduate_all_students_by_year(year_started int)
BEGIN	
	UPDATE  courses c
	JOIN students_courses sc ON c.id = sc.course_id 
	JOIN students s ON sc.student_id = s.id	
	SET s.is_graduated = TRUE
	WHERE YEAR(c.start_date) = year_started;
END $$
delimiter ;

SELECT * FROM courses c
JOIN students_courses sc ON c.id = sc.course_id 
JOIN students s ON sc.student_id = s.id 
WHERE YEAR(c.start_date) = '2017';

