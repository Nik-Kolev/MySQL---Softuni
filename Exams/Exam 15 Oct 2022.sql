CREATE DATABASE restaurants;
USE restaurants;

-- 1 Table Design
CREATE TABLE products(
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(30) NOT NULL UNIQUE,
	type varchar(30) NOT NULL,
	price decimal(10,2) NOT NULL
);

CREATE TABLE clients(
	id int PRIMARY KEY AUTO_INCREMENT,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	birthdate DATE NOT NULL,
	card varchar(50),
	review TEXT
);

CREATE TABLE tables(
	id int PRIMARY KEY AUTO_INCREMENT,
	floor int NOT NULL,
	reserved TINYINT(1),
	capacity int NOT NULL
);

CREATE TABLE waiters(
	id int PRIMARY KEY AUTO_INCREMENT, 
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	email varchar(50) NOT NULL,
	phone varchar(50),
	salary decimal (10,2)
);

CREATE TABLE orders(
	id int PRIMARY KEY AUTO_INCREMENT,
	table_id int NOT NULL,
	waiter_id int NOT NULL,
	order_time TIME NOT NULL,
	payed_status TINYINT(1),
	CONSTRAINT fk_orders_tables
	FOREIGN KEY (table_id) REFERENCES tables(id),
	CONSTRAINT fk_orders_waiters
	FOREIGN KEY (waiter_id) REFERENCES waiters(id)
);

CREATE TABLE orders_clients(
	order_id int,
	client_id int,

	CONSTRAINT fk_orders_clients_orders
	FOREIGN KEY (order_id)
	REFERENCES orders(id),
	
	CONSTRAINT fk_orders_clients_clients
	FOREIGN KEY (client_id)
	REFERENCES clients(id)
);

CREATE TABLE orders_products(
	order_id int,
	product_id int,

	CONSTRAINT fk_orders_products_orders
	FOREIGN KEY (order_id)
	REFERENCES orders(id),
	
	CONSTRAINT fk_clients_products_products
	FOREIGN KEY (product_id)
	REFERENCES products(id)
);

-- 2 Insert
INSERT INTO products (name, TYPE, price)
(SELECT concat(last_name, ' specialty'),'Cocktail', CEILING(0.01 * salary) FROM waiters w 
WHERE id > 6);

-- 3 Update
UPDATE orders 
SET table_id = table_id - 1
WHERE id BETWEEN 12 AND 23;

-- 4 Delete
-- SELECT id, (SELECT count(*) FROM orders o WHERE waiter_id = w.id) AS o_count FROM waiters w
-- HAVING o_count = 0; -- checking which waiters have 0 orders;

DELETE FROM waiters w
WHERE (SELECT count(*) FROM orders o WHERE waiter_id = w.id) = 0;

-- 5 Clients
SELECT id, first_name, last_name, birthdate, card, review FROM clients c 
ORDER BY birthdate DESC, id DESC;

-- 6 Birthdate
SELECT first_name, last_name, birthdate, review FROM clients c
WHERE card IS NULL AND YEAR(birthdate) BETWEEN 1978 AND 1993
ORDER BY last_name DESC, id
LIMIT 5;

-- 7 Accounts 
SELECT
	concat(last_name, first_name, LENGTH(first_name), 'Restaurant') AS username,
	reverse(concat(substring(email, 2, 12))) AS password
FROM
	waiters w
WHERE
	salary > 0
ORDER BY password DESC; 

-- 8 Top from menu
SELECT p.id, p.name, COUNT(p.name) AS count FROM orders_products op 
JOIN products p ON op.product_id = p.id 
GROUP BY p.name
HAVING count >= 5
ORDER BY count DESC, p.name;

-- 9 Availability
SELECT
	t.id AS table_id,
	t.capacity,
	count(oc.client_id) AS count_clients,
	(CASE 
		WHEN capacity > count(oc.client_id) THEN 'Free seats'
		WHEN capacity = count(oc.client_id) THEN 'Full'
		ELSE 'Extra seats'
	END) AS availability
FROM
	tables t
JOIN orders o ON
	o.table_id = t.id
JOIN orders_clients oc ON
	oc.order_id = o.id
WHERE
	floor = 1
GROUP BY
	t.id
ORDER BY
	t.id DESC;

-- 10 Extract bill
delimiter $$
CREATE FUNCTION udf_client_bill(full_name varchar(50))
RETURNS decimal(19,2)
DETERMINISTIC
BEGIN
	DECLARE space_index int;
	SET space_index := locate(' ', full_name);

	RETURN(
	SELECT SUM(p.price) AS bill FROM clients c 
	JOIN orders_clients oc ON oc.client_id = c.id 
	JOIN orders AS o ON oc.order_id = o.id
	JOIN orders_products op ON op.order_id = o.id 
	JOIN products p ON p.id = op.product_id
	WHERE c.first_name = SUBSTRING(full_name, 1, space_index - 1) AND
	c.last_name = SUBSTRING(full_name, space_index + 1));

END $$
delimiter ;

SELECT udf_client_bill('Silvio Blyth');

-- 11 Happy hour
delimiter $$
CREATE PROCEDURE udp_happy_hour(`type` varchar(50))
BEGIN	
	UPDATE products AS p
	SET price = price * 0.8
	WHERE p.type = `type` AND price >= 10;
END $$
delimiter ;

CALL udp_happy_hour ('Cognac');



