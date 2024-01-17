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

-- 12.	Car Rental Database
CREATE DATABASE car_rental;
USE car_rental;

CREATE TABLE categories(
	id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL,
    daily_rate DOUBLE(2,2),
    weekly_rate DOUBLE(2,2),
    monthly_rate DOUBLE(2,2),
    weekend_rate DOUBLE(2,2)
);

INSERT INTO categories (category) VALUES 
('test'),
('test'),
('test');

CREATE TABLE cars(
	id INT PRIMARY KEY AUTO_INCREMENT,
    plate_number VARCHAR(10) NOT NULL,
    make VARCHAR(30),
    model VARCHAR(20),
    car_year YEAR,
    category_id INT,
    doors CHAR,
    picture BLOB,
    car_condition VARCHAR(255),
    available BOOLEAN
);

INSERT INTO cars (plate_number) VALUES
('1'),
('2'),
('3');

CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    title VARCHAR(20),
    notes VARCHAR(255)
);

INSERT INTO employees (first_name, last_name) VALUES
('test', 'testov'),
('test2', 'testov2'),
('test3', 'testov3');

CREATE TABLE customers (
	id INT PRIMARY KEY AUTO_INCREMENT,
    driver_license_number INT NOT NULL,
    full_name VARCHAR(50),
	address VARCHAR(50),
    city VARCHAR(20),
    zip_code CHAR,
    notes VARCHAR(255)
);

INSERT INTO customers (driver_license_number) VALUES
('1234'),
('1235'),
('1236');


CREATE TABLE rental_orders (
	id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    customer_id INT NOT NULL,
    car_id INT NOT NULL,
    car_condition VARCHAR(255),
    tank_level INT,
    kilometrage_start INT,
    kilometrage_end INT,
    total_kilometrage INT,
    start_date DATETIME,
    end_date DATETIME,
    total_days INT,
    rate_applied INT,
    tax_rate INT,
    order_status INT,
    notes VARCHAR(255)
);

INSERT INTO rental_orders (employee_id, customer_id, car_id) VALUES
('1','2','3'),
('4','5','6'),
('7','8','9');

-- 13.	Basic Insert
CREATE DATABASE soft_uni;
USE soft_uni;

CREATE TABLE towns (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

INSERT INTO towns (name) VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

CREATE TABLE addresses (
	id INT PRIMARY KEY AUTO_INCREMENT,
    address_text VARCHAR(50),
    town_id INT,
    FOREIGN KEY (town_id)
		REFERENCES towns (id)
);

CREATE TABLE departments (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL
);

INSERT INTO departments (name) VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    middle_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    job_title VARCHAR(20) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id)
		REFERENCES departments (id),
	hire_date DATETIME,
    salary DOUBLE(5,2),
    address_id INT,
    FOREIGN KEY (address_id)
		REFERENCES addresses (id)
);


INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id, hire_date, salary) VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer','4', '2013-02-01', '3500.00'),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer','1', '2004-03-02', '4000.00'),
('Maria', 'Petrova', 'Ivanova', 'Intern','5', '2016-08-28', '525.25'),
('Georgi', 'Terziev', 'Ivanov', 'CEO','2', '2007-12-09', '3000.00'),
('Peter', 'Pan', 'Pan', 'Intern','3', '2016-08-28', '599.88');

-- 14.	Basic Select All Fields
SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

-- 15.	Basic Select All Fields and Order Them
SELECT * FROM towns 
ORDER BY name ASC;
SELECT * FROM departments  
ORDER BY name ASC;
SELECT * FROM employees 
ORDER BY salary DESC;

-- 16.	Basic Select Some Fields
SELECT name FROM towns
ORDER BY name ASC;
SELECT name FROM departments
ORDER BY name ASC;
SELECT first_name, last_name, job_title, salary FROM employees
ORDER BY salary DESC;

-- 17.	Increase Employees Salary
UPDATE employees SET salary = salary * 1.1;
SELECT salary FROM employees;


