CREATE DATABASE movies;
USE movies;

-- 01.	Table Design
CREATE TABLE countries(
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(30) NOT NULL UNIQUE,
	continent varchar(30) NOT NULL,
	currency varchar(5) NOT NULL
);

CREATE TABLE genres(
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(50) NOT NULL UNIQUE
);

CREATE TABLE actors(
	id int PRIMARY KEY AUTO_INCREMENT,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	birthdate date NOT NULL,
	height int,
	awards int,
	country_id int NOT NULL,
	CONSTRAINT fk_actors_countries
	FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE TABLE movies_additional_info(
	id int PRIMARY KEY AUTO_INCREMENT,
	rating decimal(10,2) NOT NULL,
	runtime int NOT NULL,
	picture_url varchar(80) NOT NULL,
	budget decimal(10,2),
	release_date date NOT NULL,
	has_subtitles tinyint(1),
	description text
);

CREATE TABLE movies(
	id int PRIMARY KEY AUTO_INCREMENT,
	title varchar(70) NOT NULL UNIQUE,
	country_id int,
	CONSTRAINT fk_movies_contries
	FOREIGN KEY (country_id) REFERENCES countries(id),
	movie_info_id int NOT NULL UNIQUE,
	CONSTRAINT fk_movies_additional_info
	FOREIGN KEY (movie_info_id) REFERENCES movies_additional_info(id)
);

CREATE TABLE movies_actors(
	movie_id int,
	actor_id int,
	CONSTRAINT fk_movies_actors_movie
	FOREIGN KEY (movie_id) REFERENCES movies(id),
	CONSTRAINT fk_movies_actors_actor
	FOREIGN KEY (actor_id) REFERENCES actors(id)
);

CREATE TABLE genres_movies(
	genre_id int,
	movie_id int,
	CONSTRAINT fk_genres_movies_genre
	FOREIGN KEY (genre_id) REFERENCES genres(id),
	CONSTRAINT fk_genres_movies_movie
	FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- 02.	Insert
INSERT INTO actors(first_name, last_name, birthdate, height, awards, country_id)
(SELECT
	reverse(first_name) AS first_name,
	reverse(last_name) AS last_name,
	date_add(birthdate, INTERVAL -2 day),
	height + 10 AS height,
	country_id AS awards,
	3 AS country_id 
FROM
	actors a 
WHERE id <= 10);

-- 03.	Update
UPDATE movies_additional_info mai
SET mai.runtime = mai.runtime - 10
WHERE mai.id BETWEEN 15 AND 25;

-- 04.	Delete
DELETE FROM countries c
WHERE (SELECT count(*) FROM movies m WHERE c.id = m.country_id) = 0;

-- 05.	Countries
SELECT * FROM countries c 
ORDER BY c.currency DESC, c.id ;

-- 06.	Old movies
SELECT mai.id, m.title, mai.runtime, mai.budget, mai.release_date  FROM movies_additional_info mai 
JOIN movies m ON mai.id = m.movie_info_id 
WHERE YEAR(mai.release_date) BETWEEN 1996 AND 1999
ORDER BY mai.runtime, mai.id 
LIMIT 20

-- 07.	Movie casting
SELECT
	concat(first_name, ' ', last_name) AS full_name,
	concat(reverse(last_name), LENGTH(last_name), '@cast.com'),
	2022 - YEAR(birthdate),
	height
FROM
	actors a
LEFT JOIN movies_actors ma ON
	a.id = ma.actor_id
WHERE
	ma.actor_id IS NULL
ORDER BY
	height
	
-- 08.	International Festival
SELECT c.name, count(*) AS movies_count FROM countries c 
JOIN movies m ON c.id = m.country_id
GROUP BY c.name 
HAVING  movies_count >= 7
ORDER BY c.name DESC

-- 09.	Rating system
SELECT
	m.title,
	(CASE
		WHEN mai.rating <= 4 THEN 'poor'
		WHEN mai.rating > 4 AND mai.rating <= 7 THEN 'good'
		ELSE 'excellent'
	END
	) AS raiting,
	(CASE
		WHEN mai.has_subtitles IS TRUE THEN 'english'
		ELSE '-'
	END
	) AS subtitles,
	budget
FROM
	movies m
JOIN movies_additional_info mai ON
	m.movie_info_id = mai.id
ORDER BY budget DESC;

-- 10.	History movies
delimiter $$
CREATE FUNCTION udf_actor_history_movies_count(full_name varchar(50))
RETURNS int
RETURN (
	SELECT
	count(*)
FROM
	actors a
JOIN movies_actors ma ON
	a.id = ma.actor_id
JOIN movies m ON
	ma.movie_id = m.id
JOIN genres_movies gm ON
	m.id = gm.movie_id
JOIN genres g ON
	gm.genre_id = g.id
WHERE
	g.id = 12
	AND a.first_name = substring_index(full_name, ' ', 1)
	AND a.last_name = substring(full_name, LENGTH(SUBSTRING_INDEX(full_name, ' ', 1)) + 2)
);
delimiter ;

-- 11.	Movie awards
delimiter $$
CREATE PROCEDURE udp_award_movie(movie_title varchar(50))
BEGIN	
	UPDATE movies m
	JOIN movies_actors ma ON m.id = ma.movie_id 
	JOIN actors a ON ma.actor_id = a.id
	SET a.awards = a.awards + 1
	WHERE m.title = movie_title;
END $$
delimiter ;

SELECT * FROM movies m
JOIN movies_actors ma ON m.id = ma.movie_id 
JOIN actors a ON ma.actor_id = a.id
WHERE m.title = 'Tea For Two'

	