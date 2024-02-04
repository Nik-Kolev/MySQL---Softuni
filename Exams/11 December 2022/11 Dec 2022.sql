CREATE DATABASE airlines;
USE airlines;
-- 01.	Table Design
CREATE TABLE countries(
	id int PRIMARY KEY AUTO_INCREMENT,
	name varchar(30) NOT NULL UNIQUE,
	description text,
	currency varchar(5) NOT NULL
);

CREATE TABLE airplanes (
	id int PRIMARY KEY AUTO_INCREMENT,
	model varchar(50) NOT NULL UNIQUE,
	passengers_capacity int NOT NULL,
	tank_capacity decimal(19,2) NOT NULL,
	cost decimal(19,2) NOT NULL 
);

CREATE TABLE passengers(
	id int PRIMARY KEY AUTO_INCREMENT,
	first_name varchar(30) NOT NULL,
	last_name varchar(30) NOT NULL,
	country_id int NOT NULL,
	CONSTRAINT fk_passengers_countries
	FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE TABLE flights(
	id int PRIMARY KEY AUTO_INCREMENT,
	flight_code varchar(30) NOT NULL UNIQUE,
	departure_country int NOT NULL,
	destination_country int NOT NULL,
	airplane_id int NOT NULL,
	has_delay tinyint(1),
	departure datetime,
	CONSTRAINT fk_flights_countries_departure
	FOREIGN KEY (departure_country) REFERENCES countries(id),
	CONSTRAINT fk_flights_countries_destination
	FOREIGN KEY (destination_country) REFERENCES countries(id),
	CONSTRAINT fk_flights_airplanes
	FOREIGN KEY (airplane_id) REFERENCES airplanes(id)
);

CREATE TABLE flights_passengers(
	flight_id int,
	passenger_id int,
	CONSTRAINT flights_passengers_flights
	FOREIGN KEY (flight_id) REFERENCES flights(id),
	CONSTRAINT flights_passengers_passenger
	FOREIGN KEY (passenger_id) REFERENCES passengers(id)
);

-- 02.	Insert
INSERT INTO airplanes(model, passengers_capacity, tank_capacity, cost)
(SELECT concat(reverse(first_name),797), SUM(LENGTH(last_name)*17), SUM(p.id*790), SUM(LENGTH(first_name)*50.6) FROM passengers p 
WHERE p.id <= 5
GROUP BY p.id);

-- 03.	Update
UPDATE flights f
SET airplane_id = airplane_id +1
WHERE f.departure_country = 22;

-- 04.	Delete
DELETE FROM flights f
WHERE (SELECT count(*) FROM flights_passengers fp WHERE f.id = fp.flight_id) = 0 ;

-- 05.	Airplanes
SELECT * FROM airplanes a 
ORDER BY cost DESC, id DESC;

-- 06.	Flights from 2022
SELECT flight_code, departure_country, airplane_id, departure  FROM flights f 
WHERE year(f.departure) = 2022
ORDER BY airplane_id, flight_code
LIMIT 20;

-- 07.	Private flights
SELECT concat(LEFT(UPPER(last_name),2), country_id) AS flight_code, concat(first_name, ' ', last_name) AS full_name, country_id FROM flights f 
RIGHT JOIN flights_passengers fp ON fp.flight_id = f.id 
RIGHT JOIN passengers p ON p.id = fp.passenger_id
WHERE f.flight_code IS NULL
ORDER BY country_id;

-- 08.	Leading destinations
SELECT c.name, c.currency, count(p.country_id) AS booked_tickets FROM countries c 
JOIN flights f ON c.id = f.destination_country
JOIN flights_passengers fp ON f.id = fp.flight_id 
JOIN passengers p ON fp.passenger_id = p.id
GROUP BY c.name 
HAVING count(p.country_id) >= 20
ORDER BY count(p.country_id) DESC;

-- 09.	Parts of the day
SELECT flight_code, departure, (CASE 
	WHEN hour(departure) BETWEEN 5 AND 11 THEN 'Morning'
	WHEN hour(departure) BETWEEN 12 AND 16 THEN 'Afternoon'
	WHEN hour(departure) BETWEEN 17 AND 20 THEN 'Evening'
	ELSE 'Night'
END) FROM flights f 
ORDER BY flight_code DESC;

-- 10.	Number of flights
delimiter $$
CREATE FUNCTION udf_count_flights_from_country(country varchar(50))
RETURNS int
RETURN (
SELECT count(*) FROM flights f 
JOIN countries c ON f.departure_country = c.id 
WHERE c.name = country);
delimiter ;

-- 11.	Delay flight
delimiter $$
CREATE PROCEDURE udp_delay_flight(code varchar(50))
BEGIN	
	UPDATE flights AS f
	SET f.departure = f.departure + INTERVAL 30 MINUTE, has_delay = 1
	WHERE f.flight_code = code;
END $$
delimiter ;

