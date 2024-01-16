-- 0. Create Database
CREATE DATABASE minions;
USE minions;

-- 1. Create Tables
CREATE TABLE minions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(47),
    age INT,
);

CREATE TABLE towns (
    town_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(47),
);

-- 2. Alter Minions Table
ALTER TABLE minions 
ADD COLUMN town_id int;

ALTER TABLE minions
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY minions(town_id)
REFERENCES towns(id);

-- 3. Insert Records in Both Tables
INSERT INTO towns(id, name) VALUES 
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

INSERT INTO minions(id, name, age, town_id) VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', null, 2);

-- 4. Truncate Table Minions
TRUNCATE TABLE minions;

-- 5. Drop All Tables
DROP TABLE minions;
DROP TABLE towns;

-- 6. Create Table People
CREATE TABLE people (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    picture BLOB,
    height DOUBLE(3 , 2 ),
    weight DOUBLE(5 , 2 ),
    gender CHAR NOT NULL,
    birthdate DATE NOT NULL,
    biography VARCHAR(255)
);

INSERT INTO people (name, gender, birthdate) VALUES
('test', 'm', NOW()),
('testche', 'f', NOW()),
('test', 'm', NOW()),
('testche', 'f', NOW()),
('test', 'm', NOW());

-- 7. Create Table Users
CREATE TABLE users(
	id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(26) NOT NULL,
    profile_picture BLOB,
    last_login_time DATETIME,
    is_deleted BOOLEAN
);

INSERT INTO users(username, password) VALUES
('test', 'test'),
('test', 'test'),
('test', 'test'),
('test', 'test'),
('test', 'test');

-- 8. Change Primary Key
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users2
PRIMARY KEY users(id, username);

-- 9. Set Default Value of a Field
ALTER TABLE users
CHANGE COLUMN last_login_time 
last_login_time DATETIME DEFAULT NOW();

-- 10. Set Unique Field
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY users(id),
CHANGE COLUMN username
username VARCHAR(30) UNIQUE;

-- 11.	Movies Database
CREATE DATABASE movies;
USE movies;

CREATE TABLE directors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    director_name VARCHAR(50) NOT NULL,
    notes TEXT
);

INSERT INTO directors(director_name) VALUES
('test'),
('test'),
('test'),
('test'),
('test');

CREATE TABLE genres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(20) NOT NULL,
    notes TEXT
);

INSERT INTO genres(genre_name) VALUES
('test'),
('test'),
('test'),
('test'),
('test');

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(20) NOT NULL,
    notes TEXT
);

INSERT INTO categories(category_name) VALUES
('test'),
('test'),
('test'),
('test'),
('test');

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50) NOT NULL,
    director_id INT,
    copyright_year YEAR,
    length DOUBLE(10 , 2 ),
    genre_id INT,
    category_id INT,
    rating DOUBLE(2 , 2 ),
    notes TEXT
--  FOREIGN KEY (director_id)
--         REFERENCES directors (id),
--     FOREIGN KEY (genre_id)
--         REFERENCES genres (id),
--     FOREIGN KEY (category_id)
--         REFERENCES categories (id)
-- THIS WAS NOT REQUIRED FOR THE EXERCISE AND WILL FAIL 1 TEST !
);

INSERT INTO movies (title) VALUES
('test'),
('test'),
('test'),
('test'),
('test');
