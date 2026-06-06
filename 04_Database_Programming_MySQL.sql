# 1. Создать процедуру, в которой мы получаем на вход два параметра p_salary, p_dept и на выходе получим:
# - Список сотрудников (emp_no, first_name, gender), у которых средняя зарплата больше p_salary и которые когда-то работали в департаменте p_dept.
USE employees;
DROP PROCEDURE IF EXISTS PRO_Get_Employees_With_AvgSalary_Above_In_Dept;
DELIMITER $$
CREATE PROCEDURE PRO_Get_Employees_With_AvgSalary_Above_In_Dept
(
	IN p_salary DECIMAL ( 15 , 2 ),
	IN p_dept VARCHAR (4)
)
BEGIN
	SELECT E.emp_no, E.first_name, E.gender FROM employees E
    JOIN salaries S ON E.emp_no = S.emp_no
    JOIN dept_emp DE ON E.emp_no = DE.emp_no
    WHERE DE.dept_no = p_dept
    GROUP BY E.emp_no, E.first_name, E.gender
    HAVING AVG(S.salary) > p_salary;
 END $$
DELIMITER ;
CALL PRO_Get_Employees_With_AvgSalary_Above_In_Dept ('67000', 'd004');
#П Р О В Е Р К А ===========================
SELECT E.emp_no, E.first_name, E.gender, AVG(S.salary) FROM employees E
    JOIN salaries S ON E.emp_no = S.emp_no
    JOIN dept_emp DE ON E.emp_no = DE.emp_no
    WHERE DE.dept_no = 'd004'
    GROUP BY E.emp_no, E.first_name, E.gender
    HAVING AVG(S.salary) > 67000;
#=======================================================================================================================================================
# 2. Создать функцию, которая получает на вход f_name и выдает максимальную зарплату среди сотрудников с именем f_name.
USE employees;
DROP FUNCTION IF EXISTS F_GetMaxSalaryByFirstName;
DELIMITER $$
CREATE FUNCTION F_GetMaxSalaryByFirstName (F_first_name VARCHAR (14)) RETURNS DECIMAL ( 15 , 2 )
DETERMINISTIC READS SQL DATA
BEGIN
	DECLARE F_MAX_salary DECIMAL ( 15 , 2 );
    SELECT MAX(salary) INTO F_MAX_salary
    FROM salaries S
    JOIN employees E
    ON S.emp_no = E.emp_no
    WHERE E.first_name = F_first_name;
    RETURN F_MAX_salary;
END $$
DELIMITER ;
SELECT F_GetMaxSalaryByFirstName ('Georgi');
#П Р О В Е Р К А ===========================
SELECT MAX(salary) FROM salaries S
JOIN employees E
ON S.emp_no = E.emp_no
WHERE E.first_name = 'Georgi';
#=======================================================================================================================================================
# Следующие запросы относятся к базе данных World (скачайте ее ниже, и запустите все запросы, как мы делали с employees):
# 1. Посчитайте количество городов в каждой стране, где IndepYear = 1991 (Independence Year).
# Здесь будем использовать хранимую процедуру, потому что возвращает табличный результат
DROP PROCEDURE IF EXISTS PRO_Get_City_Count_By_IndepYear;
DELIMITER $$
CREATE PROCEDURE PRO_Get_City_Count_By_IndepYear (IN PRO_IndepYear VARCHAR (4))
BEGIN
	SELECT CTR.name AS Name, COUNT(*) AS City_Count FROM country CTR
    JOIN city CI
    ON CTR.code = CI.CountryCode
    WHERE CTR.IndepYear = PRO_IndepYear
    GROUP BY CTR.name;
 END $$
DELIMITER ;
CALL PRO_Get_City_Count_By_IndepYear (1991);
#П Р О В Е Р К А ===========================
USE world;
SELECT CTR.name, COUNT(*) FROM country CTR
JOIN city CI
ON CTR.code = CI.CountryCode
WHERE CTR.IndepYear = 1991
GROUP BY CTR.name;
#=======================================================================================================================================================
# 2. Узнайте, какая численность населения и средняя продолжительность жизни людей в Аргентине (ARG).
USE world;
DROP PROCEDURE IF EXISTS PRO_Get_Country_Status;
DELIMITER $$
CREATE PROCEDURE PRO_Get_Country_Status (IN p_country_code CHAR(10))
BEGIN
    SELECT 
		Name AS Name,
		Population AS Population,
		ROUND(LifeExpectancy, 2 ) AS Life_Expectancy
    FROM Country
    WHERE Code = p_country_code;
END $$
DELIMITER ;
CALL PRO_Get_Country_Status ('ARG');
#П Р О В Е Р К А ===========================
USE world;
SELECT name as Name, population as Population, round(AVG(LifeExpectancy) , 2 ) AVG_Life_Expectancy FROM country
WHERE code = 'ARG';
#=======================================================================================================================================================
# 3. В какой стране самая высокая продолжительность жизни?
USE world;
DROP PROCEDURE IF EXISTS PRO_Get_Max_Life_Expectancy;
DELIMITER $$
CREATE PROCEDURE PRO_Get_Max_Life_Expectancy ()
BEGIN
    SELECT 
		Name AS Name,
		ROUND(LifeExpectancy, 2 ) AS Life_Expectancy
        FROM Country
    WHERE LifeExpectancy = (SELECT MAX(LifeExpectancy) FROM country);
END $$
DELIMITER ;
CALL PRO_Get_Max_Life_Expectancy ();
#П Р О В Е Р К А ===========================
USE world;
SELECT Name, LifeExpectancy
FROM Country
ORDER BY LifeExpectancy DESC
LIMIT 1;
#=======================================================================================================================================================
# 4. Перечислите все языки, на которых говорят в регионе «Southeast Asia».
USE world;
DROP PROCEDURE IF EXISTS PRO_List_Languages_By_Region;
DELIMITER $$
CREATE PROCEDURE PRO_List_Languages_By_Region (IN p_region CHAR(50))
BEGIN
    SELECT 
		DISTINCT CL.Language as Language
        FROM Country C
        JOIN countrylanguage CL
        ON C.code = CL.countrycode
    WHERE C.region = p_region;
END $$
DELIMITER ;
CALL PRO_List_Languages_By_Region ('Southeast Asia');
#П Р О В Е Р К А ===========================
SELECT DISTINCT CL.Language
	FROM Country C
	JOIN countrylanguage CL
	ON C.code = CL.countrycode
WHERE C.region = 'Southeast Asia';
#=======================================================================================================================================================
# 5. Посчитайте сумму SurfaceArea для каждого континента.
USE world;
DROP PROCEDURE IF EXISTS PRO_Get_Surface_Area_By_Continent;
DELIMITER $$
CREATE PROCEDURE PRO_Get_Surface_Area_By_Continent ()
BEGIN
    SELECT 
		Continent,
        SUM(SurfaceArea) AS Total_Surface_Area
        FROM Country
	GROUP BY Continent;
END $$
DELIMITER ;
CALL PRO_Get_Surface_Area_By_Continent ();
#П Р О В Е Р К А ===========================
SELECT Continent, SUM(SurfaceArea) AS Total_Surface_Area FROM Country
GROUP BY Continent;


