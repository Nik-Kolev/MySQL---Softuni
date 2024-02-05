CREATE DATABASE real_estate;
USE real_estate;
-- 01.	Table Design
CREATE TABLE cities(
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(60) NOT NULL UNIQUE
);

CREATE TABLE property_types(
	id int PRIMARY KEY AUTO_INCREMENT,
	`type` varchar(40) NOT NULL UNIQUE,
	description text
);

CREATE TABLE properties (
	id int PRIMARY KEY AUTO_INCREMENT,
	address varchar(80) NOT NULL UNIQUE,
	price decimal(19,2) NOT NULL,
	area decimal(19,2),
	property_type_id int,
	city_id int,
	CONSTRAINT fk_properties_type
	FOREIGN KEY (property_type_id) REFERENCES property_types(id),
	CONSTRAINT fk_properties_city
	FOREIGN KEY (city_id) REFERENCES cities(id)
);

CREATE TABLE agents (
	id int PRIMARY KEY AUTO_INCREMENT,
	first_name varchar(40) NOT NULL,
	last_name varchar(40) NOT NULL,
	phone varchar(20) NOT NULL UNIQUE,
	email varchar(50) NOT NULL UNIQUE,
	city_id int,
	CONSTRAINT fk_agents_city
	FOREIGN KEY (city_id) REFERENCES cities(id)
);

CREATE TABLE buyers (
	id int PRIMARY KEY AUTO_INCREMENT,
	first_name varchar(40) NOT NULL,
	last_name varchar(40) NOT NULL,
	phone varchar(20) NOT NULL UNIQUE,
	email varchar(50) NOT NULL UNIQUE,
	city_id int,
	CONSTRAINT fk_buyers_city
	FOREIGN KEY (city_id) REFERENCES cities(id)
);

CREATE TABLE property_offers (
	property_id int,
	agent_id int,
	price decimal(19,2) NOT NULL,
	offer_datetime datetime,
	CONSTRAINT fk_property_offers_property
	FOREIGN KEY (property_id) REFERENCES properties(id),
	CONSTRAINT fk_property_offers_agent
	FOREIGN KEY (agent_id) REFERENCES agents(id)
);

CREATE TABLE property_transactions (
	id int PRIMARY KEY AUTO_INCREMENT,
	property_id int,
	buyer_id int,
	transaction_date date,
	bank_name varchar(30),
	iban varchar(40) UNIQUE,
	is_successful tinyint(1),
	CONSTRAINT fk_property_transactions_property
	FOREIGN KEY (property_id) REFERENCES properties(id),
	CONSTRAINT fk_property_transactions_buyer
	FOREIGN KEY (buyer_id) REFERENCES buyers(id)
);

-- 02. Insert
INSERT INTO property_transactions(property_id, buyer_id, transaction_date, bank_name, iban, is_successful)
SELECT
   po.agent_id + DAY(po.offer_datetime) AS property_id,
   po.agent_id + MONTH(po.offer_datetime) AS buyer_id,
   date(po.offer_datetime) AS transaction_date,
   concat('Bank', ' ', po.agent_id) AS bank_name,
   concat('BG', po.price, po.agent_id) AS iban,
   1 AS is_successful
FROM
   property_offers po
WHERE
   po.agent_id <= 2;

-- concat(po.agent_id, DAY(po.offer_datetime)) and concat(po.agent_id, MONTH(po.offer_datetime))
-- does not work as they interfere with the foreign key for some reason, but + works
  
-- 03. Update
 UPDATE properties 
 SET price = price - 50000
 WHERE price >= 800000;

-- 04. Delete
DELETE FROM property_transactions 
WHERE is_successful = 0;

-- 05.	Agents
SELECT * FROM agents 
ORDER BY city_id DESC, phone DESC;

-- 06.	Offers from 2021
SELECT * FROM property_offers
WHERE year(offer_datetime) = 2021
ORDER BY price
LIMIT 10;

-- 07.	Properties without offers
SELECT LEFT(address, 6) AS agent_name, LENGTH(address)*5430 AS price FROM properties p
LEFT JOIN property_offers po ON p.id = po.property_id
WHERE po.agent_id IS NULL
ORDER BY agent_name DESC, price DESC;

-- 08.	Best Banks
SELECT bank_name, count(iban) FROM property_transactions pt 
GROUP BY bank_name 
HAVING count(iban) >= 9
ORDER BY count(iban) DESC, bank_name;

-- 09.	Size of the area
SELECT
	address,
	area,
	(CASE  
		WHEN area <= 100 THEN 'small'
		WHEN area <= 200 THEN 'medium'
		WHEN area <= 500 THEN 'large'
		ELSE 'extra large'
	END) AS size
FROM
	properties p 
ORDER BY area, address DESC

-- 10.	Offers count in a city
delimiter $$
CREATE FUNCTION udf_offers_from_city_name(cityName varchar(50))
RETURNS int
RETURN (
SELECT count(c.id) FROM cities c 
JOIN properties p ON c.id = p.city_id 
JOIN property_offers po ON p.id = po.property_id
WHERE c.name = cityName
GROUP BY c.name
)
delimiter ;

-- 11.	Special Offer
delimiter $$
CREATE PROCEDURE udp_special_offer(first_name varchar(50))
BEGIN
	UPDATE property_offers po
	JOIN agents a ON a.id = po.agent_id 
	SET po.price = po.price * 0.9
	WHERE a.first_name = first_name;
END $$
delimiter ;

SELECT * FROM property_offers po 
JOIN agents a ON a.id = po.agent_id 
WHERE a.first_name = 'Hans'