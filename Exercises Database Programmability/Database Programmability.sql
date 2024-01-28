-- 1.	Employees with Salary Above 35000
delimiter $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
SELECT
	first_name,
	last_name
FROM
	employees e
WHERE
	salary > 35000
ORDER BY
	first_name,
	last_name,
	employee_id;
END $$
delimiter ;

CALL usp_get_employees_salary_above_35000();

-- 2.	Employees with Salary Above Number
delimiter $$
CREATE PROCEDURE usp_get_employees_salary_above(treshhold DOUBLE(19,4))
BEGIN 
	SELECT first_name, last_name FROM employees e 
	WHERE salary >= treshhold
	ORDER BY first_name, last_name, employee_id;
END $$
delimiter ;

CALL usp_get_employees_salary_above(45000);

-- 3.	Town Names Starting With
delimiter $$
CREATE PROCEDURE usp_get_towns_starting_with(starts_with varchar(50))
BEGIN	
	SELECT name FROM towns t
	WHERE left(name, LENGTH(starts_with)) = starts_with
	ORDER BY name;
END $$
delimiter ;

CALL usp_get_towns_starting_with ('be');

-- 4.	Employees from Town
delimiter $$
CREATE PROCEDURE usp_get_employees_from_town(town_name varchar(50))
BEGIN	
	SELECT e.first_name, e.last_name  FROM towns t 
	JOIN addresses a ON a.town_id = t.town_id 
	JOIN employees e ON e.address_id = a.address_id 
	WHERE t.name = town_name
	ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
delimiter ;

CALL usp_get_employees_from_town('Sofia');

-- 5.	Salary Level Function
delimiter $$
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(19,4))
RETURNS varchar (7)
RETURN (
	CASE 
		WHEN salary < 30000 THEN 'Low'
		WHEN salary <= 50000 THEN 'Average'
		ELSE 'High'
	END
);
delimiter ;

SELECT ufn_get_salary_level(44440);

-- 6.	Employees by Salary Level
delimiter $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_param varchar(7))
BEGIN
	SELECT first_name, last_name  FROM employees e 
	WHERE salary_param = 'High' AND  salary > 50000 OR 
			 salary_param = 'Low' AND  salary < 30000 OR 
			 salary_param = 'Average' AND  salary >= 30000 AND salary <= 50000
	ORDER BY first_name DESC , last_name DESC;
END	$$
delimiter ;
	
CALL usp_get_employees_by_salary_level('high');

-- 7.	Define Function
delimiter $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS int
RETURN word REGEXP (CONCAT('^[', set_of_letters, ']+$'));
delimiter ;

SELECT ufn_is_word_comprised('Nik', 'Niko');
	
-- 8.	Find Full Name
delimiter $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN	
	SELECT concat(first_name, ' ', last_name) AS full_name FROM account_holders ah 
	ORDER BY full_name, id;
END $$

delimiter ;

CALL usp_get_holders_full_name();

-- 9.	People with Balance Higher Than
delimiter $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(num int)
BEGIN
	SELECT first_name, last_name FROM accounts a 
	JOIN account_holders ah ON a.account_holder_id = ah.id 
	GROUP BY a.account_holder_id 
	HAVING SUM(a.balance) > num
	ORDER BY a.account_holder_id;
END $$
delimiter ;

CALL usp_get_holders_with_balance_higher_than(7000);

-- 10.	Future Value Function
delimiter $$
CREATE FUNCTION ufn_calculate_future_value(sum decimal(19,4), yearly_interest_rate decimal(19,4), num_years int)
RETURNS decimal(19,4)
RETURN (
	sum * POW((1 + yearly_interest_rate),num_years)
);

delimiter ;

SELECT ufn_calculate_future_value(1000,0.5,5);

-- 11.	Calculating Interest
delimiter $$
CREATE PROCEDURE usp_calculate_future_value_for_account(param_id int, param_interest decimal(19,4))
BEGIN	
	SELECT
	a.id AS account_id,
	ah.first_name ,
	ah.last_name,
	a.balance,
	ufn_calculate_future_value(a.balance, param_interest, 5) AS balance_in_5_years
FROM
	account_holders ah
JOIN accounts a ON
	a.account_holder_id = ah.id
WHERE
	a.id = param_id;
END $$
delimiter ;

CALL usp_calculate_future_value_for_account(1, 0.1);

-- 12.	Deposit Money
delimiter $$
CREATE PROCEDURE usp_deposit_money(account_id int, money_amount decimal(19,4))
BEGIN	
		START TRANSACTION;
		IF money_amount <= 0 THEN ROLLBACK;
		ELSE
			UPDATE accounts SET balance = balance + money_amount WHERE id = account_id;
		END IF;
	COMMIT;
END $$
delimiter ;

CALL usp_deposit_money(1, 10);

-- 13.	Withdraw Money
delimiter $$
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
	
	START TRANSACTION;
		IF (money_amount <= 0 OR (SELECT balance FROM accounts WHERE id = account_id) < money_amount) THEN ROLLBACK;
		ELSE
			UPDATE accounts SET balance = balance - money_amount WHERE id = account_id;
		END IF;
	COMMIT;
	
END $$
delimiter ;

-- 14.	Money Transfer
delimiter $$
CREATE PROCEDURE usp_transfer_money(from_account_id int, to_account_id int, amount decimal(19,4))
BEGIN
	START TRANSACTION;
		IF from_account_id NOT IN (SELECT id FROM accounts) THEN ROLLBACK;
		ELSEIF to_account_id NOT IN (SELECT id FROM accounts) THEN ROLLBACK;
		ELSEIF from_account_id = to_account_id THEN ROLLBACK;
		ELSEIF amount <= 0 THEN ROLLBACK;
		ELSEIF (SELECT balance FROM accounts WHERE id = from_account_id) < amount THEN ROLLBACK;
		ELSE
			UPDATE accounts SET balance = balance - amount WHERE id = from_account_id;
			UPDATE accounts SET balance	= balance + amount WHERE id = to_account_id;
		END IF;
	COMMIT;
END $$
delimiter ;

CALL usp_transfer_money(1,2, 33);

-- 15.	Log Accounts Trigger
CREATE TABLE logs(
	log_id int PRIMARY KEY AUTO_INCREMENT,
	account_id int NOT NULL,
	old_sum decimal(19,4) NOT NULL,
	new_sum decimal(19,4) NOT NULL
);

CREATE TRIGGER tr_update_balance
AFTER UPDATE
ON accounts
FOR EACH ROW 
BEGIN 
	INSERT INTO logs(account_id, old_sum, new_sum)
	VALUES (OLD.id, OLD.balance, NEW.balance);
END	
	
-- 16.	Emails Trigger
CREATE TABLE notification_emails(
	id int PRIMARY KEY AUTO_INCREMENT,
	recipient int NOT NULL,
	subject varchar(100) NOT NULL,
	body text NOT NULL
);

CREATE TRIGGER tr_notification_email_creation
AFTER INSERT ON logs FOR EACH ROW 
BEGIN 
	INSERT
	INTO
	notification_emails(recipient,
	subject,
	body)
VALUES (NEW.account_id,
concat('Balance change for account: ', NEW.account_id,
	concat_ws(' ', 'On', DATE_FORMAT(now(), '%b %d %y at %r') + 'your balance was changed from'
	+ NEW.old_sum, 'to', NEW.new_sum));
END



