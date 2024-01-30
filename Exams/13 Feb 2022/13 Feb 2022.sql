CREATE DATABASE online_store;
USE online_store;

-- 1 Table Design
CREATE TABLE brands (
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(40) NOT NULL UNIQUE 
);

CREATE TABLE categories (
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(40) NOT NULL UNIQUE 
);

CREATE TABLE reviews (
	id int PRIMARY KEY AUTO_INCREMENT,
	content text,
	rating decimal(10,2) NOT NULL,
	picture_url varchar(80) NOT NULL,
	published_at datetime NOT NULL
);

CREATE TABLE products (
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(40) NOT NULL,
	price decimal(19,2) NOT NULL,
	quantity_in_stock int,
	description text,
	brand_id int NOT NULL,
	category_id int NOT NULL,
	review_id int NOT NULL,
	constraint fk_products_brand 
	FOREIGN KEY (brand_id) 
	REFERENCES brands(id),
	constraint fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id),
	constraint fk_products_review FOREIGN KEY (review_id) REFERENCES reviews(id)
);

CREATE TABLE customers (
	id int PRIMARY KEY AUTO_INCREMENT,
	first_name varchar(20) NOT NULL,
	last_name varchar(20) NOT NULL,
	phone varchar(30) NOT NULL UNIQUE,
	address varchar(60) NOT NULL,
	discount_card bit(1) NOT NULL DEFAULT FALSE
);

CREATE TABLE orders (
	id int PRIMARY KEY AUTO_INCREMENT, 
	order_datetime datetime NOT NULL,
	customer_id int NOT NULL,
	CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE orders_products (
	order_id int,
	product_id int,
	constraint fk_orders_products_order FOREIGN KEY (order_id) REFERENCES orders(id),
	constraint fk_orders_products_product FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 2 Insert
INSERT INTO reviews (content, rating, picture_url, published_at )
SELECT LEFT(p.description, 15), p.price/8, reverse(p.name), '2010-10-10' FROM products AS p
WHERE p.id >= 5;

-- 3 Update
UPDATE products 
SET quantity_in_stock = quantity_in_stock - 5
WHERE quantity_in_stock BETWEEN 60 AND 70;

-- 4 Delete
DELETE FROM customers c
WHERE (SELECT count(*) FROM orders o WHERE customer_id = c.id) = 0;

-- SELECT * FROM customers c 
-- LEFT JOIN orders o ON o.customer_id = c.id 
-- WHERE o.customer_id IS NULL; -- another way to delete the customers that do not have orders

-- DELETE FROM customers 
-- WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders) -- another way with select

-- 5 Categories  
SELECT id, name FROM categories c 
ORDER BY name DESC;

-- 6 Quantity
SELECT id, brand_id, name, quantity_in_stock  FROM products p 
WHERE price > 1000 AND quantity_in_stock < 30
ORDER BY quantity_in_stock, id;

-- 7 Review
SELECT id, content, rating, picture_url, published_at FROM reviews r 
WHERE substring(content, 1, 2) = 'My' AND LENGTH(content) > 61
ORDER BY rating DESC;

-- 8 First customers
SELECT concat(first_name, ' ', last_name) AS full_name, address, o.order_datetime  FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE YEAR(o.order_datetime) <= 2018
ORDER BY full_name DESC;

-- 9 Best categories
SELECT count(p.category_id) AS item_count, c.name, SUM(p.quantity_in_stock) AS total_quantity FROM products p
JOIN categories c ON p.category_id = c.id
GROUP BY p.category_id
ORDER BY item_count DESC, total_quantity
LIMIT 5; 

-- 10 Extract client cards count
delimiter $$
CREATE FUNCTION udf_customer_products_count(name varchar(30))
RETURNS int
RETURN (
SELECT count(*) AS total_products FROM customers c 
JOIN orders o ON c.id = o.customer_id
JOIN orders_products op ON o.id = op.order_id 
WHERE c.first_name = name);
	
SELECT c.first_name,c.last_name, udf_customer_products_count('Shirley') as `total_products` FROM customers c
WHERE c.first_name = 'Shirley'; 

-- 11 Reduce price
delimiter $$
CREATE PROCEDURE udp_reduce_price(category_name varchar(50))
BEGIN 
	UPDATE products AS p
	JOIN categories c ON p.category_id = c.id 
	JOIN reviews r ON p.review_id = r.id  
	SET p.price = p.price * 0.7
	WHERE c.name = category_name AND r.rating < 4;
END $$
delimiter ;

CALL udp_reduce_price('Phones and tablets');

SELECT * FROM products p
JOIN categories c ON p.category_id = c.id 
JOIN reviews r ON p.review_id = r.id 
WHERE c.name = 'Phones and tablets' AND r.rating < 4;
