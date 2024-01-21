-- 1. Records' Count
SELECT count(*) AS 'count' FROM wizzard_deposits wd; 

-- 2. Longest Magic Wand
SELECT max(magic_wand_size) AS 'longest_magic_wand' FROM wizzard_deposits wd ;

-- 3. Longest Magic Wand Per Deposit Groups
SELECT deposit_group, max(magic_wand_size) AS 'longest_magic_wand' FROM wizzard_deposits wd
GROUP BY deposit_group 
ORDER BY max(magic_wand_size), deposit_group ;

-- 4. Smallest Deposit Group Per Magic Wand Size*
SELECT deposit_group FROM wizzard_deposits wd 
GROUP BY deposit_group 
HAVING min(magic_Wand_size)
LIMIT 1;

-- 5. Deposits Sum
SELECT deposit_group, sum(deposit_amount) AS 'total_sum' FROM wizzard_deposits wd 
GROUP BY deposit_group 
ORDER BY `total_sum`;

-- 6. Deposits Sum for Ollivander Family
SELECT deposit_group, sum(deposit_amount) AS 'total_sum' FROM wizzard_deposits wd
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group 
ORDER BY deposit_group;

-- 7. Deposits Filter
SELECT deposit_group, sum(deposit_amount) AS 'total_sum' FROM wizzard_deposits wd 
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group 
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC;

-- 8. Deposit Charge
SELECT deposit_group, magic_wand_creator, min(deposit_charge) AS 'min_deposit' FROM wizzard_deposits wd 
GROUP BY deposit_group, magic_wand_creator
ORDER BY magic_wand_creator, deposit_group ;

-- 9. Age Groups
SELECT age FROM wizzard_deposits wd ;


-- 10. First Letter
SELECT DISTINCT LEFT(first_name,1) FROM wizzard_deposits wd 
WHERE wd.deposit_group = 'Troll Chest'
ORDER BY LEFT(first_name,1);

-- 11. Average Interest 


-- 12. Employees Minimum Salaries

-- 13. Employees Average Salaries

-- 14. Employees Maximum Salaries

-- 15. Employees Count Salaries

-- 16. 3rd Highest Salary*

-- 17. Salary Challenge**

-- 18. Departments Total Salaries