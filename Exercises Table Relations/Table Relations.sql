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

-- 3.	Many-To-Many Relationship

CREATE TABLE students (
	student_id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(50) NOT NULL
);

INSERT INTO students (name) VALUES 
('Mila'),
('Toni'),
('Ron');

CREATE TABLE exams (
	exam_id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(50) NOT null
) AUTO_INCREMENT = 101;


INSERT INTO exams (name) VALUES 
('Spring MVC'),
('Neo4j'),
('Oracle 11g');

CREATE TABLE
    students_exams (
        student_id INT,
        exam_id INT,
        CONSTRAINT pk_students_exams PRIMARY KEY (student_id, exam_id),
        CONSTRAINT fk_students_exams FOREIGN KEY (student_id) REFERENCES students (student_id),
        CONSTRAINT fk_exams_students FOREIGN KEY (exam_id) REFERENCES exams (exam_id)
    );

   
   INSERT INTO students_exams VALUES 
   (1, 101),
   (1, 102),
   (2, 101),
   (3, 103),
   (2, 102),
   (2, 103);
  
  -- 4.	Self-Referencing
CREATE TABLE
    teachers (
        teacher_id INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(20),
        manager_id INT
    );

ALTER TABLE teachers AUTO_INCREMENT = 101;

INSERT INTO
    teachers (name, manager_id)
VALUES
    ('John', NULL),
    ('Maya', 106),
    ('Silvia', 106),
    ('Ted', 105),
    ('Mark', 101),
    ('Greta', 101);

ALTER TABLE teachers ADD CONSTRAINT fk_manager_teacher FOREIGN KEY (manager_id) REFERENCES teachers (teacher_id);

-- 5.	Online Store Database
CREATE TABLE cities (
	city_id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(50)
);

CREATE TABLE item_types (
	item_type_id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(50)
);

CREATE TABLE customers (
	customer_id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(50),
	birthday DATE,
	city_id int,
	CONSTRAINT fk_customers_cities
	FOREIGN KEY (city_id)
	REFERENCES cities(city_id)
);

CREATE TABLE orders (
	order_id int PRIMARY KEY AUTO_INCREMENT,
	customer_id int,
	CONSTRAINT fk_orders_customers
	FOREIGN KEY (customer_id)
	REFERENCES customers(customer_id)
);

CREATE TABLE items (
	item_id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(50),
	item_type_id int,
	CONSTRAINT fk_items_item_types
	FOREIGN KEY (item_type_id)
	REFERENCES item_types(item_type_id)
);

CREATE TABLE order_items (
	order_id int,
	item_id int,
	CONSTRAINT pk_order_items PRIMARY KEY (order_id, item_id),
	CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
	CONSTRAINT fk_order_items_items FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- 6.	University Database
  
  CREATE TABLE subjects (
 	subject_id int PRIMARY KEY AUTO_INCREMENT,
 	subject_name varchar(50) NOT null
  );
 
 CREATE TABLE majors (
	major_id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(50) NOT null
);
 
 CREATE TABLE students (
	student_id int PRIMARY KEY AUTO_INCREMENT,
	student_number varchar(12) NOT NULL,
	student_name varchar(50) NOT NULL,
	major_id int,
	CONSTRAINT fk_students_majors
	FOREIGN KEY (major_id)
	REFERENCES majors(major_id)
 );

CREATE TABLE payments (
	payment_id int PRIMARY KEY AUTO_INCREMENT,
	payment_date DATE,
	payment_amount DECIMAL(8,2),
	student_id int,
	CONSTRAINT fk_payments_students
	FOREIGN KEY (student_id)
	REFERENCES students(student_id)
);

CREATE TABLE agenda (
	student_id int,
	subject_id int,
	CONSTRAINT pk_agenda PRIMARY KEY(student_id, subject_id),
	CONSTRAINT fk_agenda_subjects FOREIGN KEY (student_id) REFERENCES students(student_id),
	CONSTRAINT fk_agenda_students FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- 9.	Peaks in Rila

SELECT mountain_range, peak_name, elevation AS 'peak_elevation' FROM mountains m
JOIN peaks p  ON m.id = p.mountain_id 
WHERE m.mountain_range  = 'Rila'
ORDER BY elevation desc;

