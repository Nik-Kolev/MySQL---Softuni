-- 1.	One-To-One Relationship
CREATE TABLE table_relations;
USE table_relations;

CREATE TABLE people (
	person_id int UNIQUE NOT NULL AUTO_INCREMENT,
	first_name varchar(50) NOT NULL,
	salary decimal(10,2) DEFAULT 0,
	passport_id int UNIQUE	
);

CREATE TABLE passports (
	passport_id int PRIMARY KEY AUTO_INCREMENT,
	passport_number varchar(8) UNIQUE
);

ALTER TABLE people 
ADD CONSTRAINT pk_people
PRIMARY KEY (person_id),
ADD CONSTRAINT fk_people_passports
FOREIGN KEY (passport_id)
REFERENCES passports(passport_id);


INSERT  INTO passports (passport_id, passport_number) VALUES 
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2');

INSERT  INTO people (first_name, salary, passport_id) VALUES 
('Roberto', 43300, 102),
('Tom', 56100, 103),
('Yana', 60200, 101);

-- 2.	One-To-Many Relationship

CREATE TABLE manufacturers (
	manufacturer_id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(50) UNIQUE NOT NULL,
	established_on DATE NOT NULL
);

CREATE TABLE models (
	model_id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(20) NOT NULL,
	manufacturer_id int,
	CONSTRAINT fk_models_manufacturers
	FOREIGN KEY (manufacturer_id)
	REFERENCES manufacturers(manufacturer_id)
);

ALTER TABLE models AUTO_INCREMENT = 101;

INSERT INTO manufacturers (name, established_on) VALUES 
('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01');

INSERT INTO models (name, manufacturer_id) VALUES 
('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3);




