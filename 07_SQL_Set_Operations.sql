# 1. Объединение сотрудников и менеджеров: Напишите запрос, который использует UNION для объединения списка всех сотрудников (мужчин) и всех менеджеров (только идентификаторы сотрудников emp_no).
SELECT emp_no FROM employees
WHERE gender = 'M'
UNION
SELECT emp_no FROM dept_manager;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2. Список уникальных должностей и отделов: Создайте запрос, который объединяет уникальные названия должностей из таблицы titles и названия отделов из departments.
SELECT DISTINCT title FROM titles
UNION
SELECT dept_name FROM departments;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 3. Сотрудники с зарплатами выше и ниже среднего: Напишите запрос, который использует UNION для объединения двух списков:
# сотрудников с зарплатой выше 60.000 долларов и
# сотрудников с зарплатой ниже 40.000 долларов (используйте имя и зарплату).
SELECT E.first_name, E.last_name, S.salary FROM salaries S
JOIN employees E
ON S.emp_no = E.emp_no
WHERE salary > 60000
UNION
SELECT E.first_name, E.last_name, S.salary FROM salaries S
JOIN employees E
ON S.emp_no = E.emp_no
WHERE salary < 40000;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 4. Объединение текущих и бывших сотрудников: Используйте UNION для создания списка сотрудников,
# которые в настоящее время работают в компании, и тех, кто уже ушел (используйте имя, фамилию и статус 'Текущий' или 'Бывший' ,
# то есть first_name, last_name, 'Текущий' AS status, 'Бывший' AS status ).
SELECT E.first_name, E.last_name,
CASE
	WHEN DE.to_date = '9999-01-01' THEN 'Current'
	ELSE 'Former'
END AS 'Employee_status'
FROM employees E
JOIN dept_emp DE
ON E.emp_no = DE.emp_no
HAVING Employee_status = 'Current'
#============================
UNION
#============================
SELECT E.first_name, E.last_name,
CASE
	WHEN DE.to_date = '9999-01-01' THEN 'Current'
	ELSE 'Former'
END AS 'Employee_status'
FROM employees E
JOIN dept_emp DE
ON E.emp_no = DE.emp_no
HAVING Employee_status = 'Former'
ORDER BY Employee_status;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 5. Сравнение зарплат менеджеров и обычных сотрудников:
# Создайте запрос с использованием UNION, чтобы сравнить средние зарплаты менеджеров и обычных сотрудников
# (выведите тип сотрудника, либо Менеджер, либо Обычный сотрудник их среднюю зарплату, то есть 'Менеджер' AS type, 'Обычный сотрудник' AS type, AVG(salary) AS avg_salary ).
SELECT 'Manager' AS 'Type', ROUND(AVG(S.salary),2) AS 'Avegare_salary' FROM salaries S
JOIN dept_manager DM
ON S.emp_no = DM.emp_no
UNION
SELECT 'Ordinary employee' AS 'Type', ROUND(AVG(S.salary),2) AS 'Avegare_salary' FROM salaries S
JOIN dept_manager DM
ON S.emp_no <> DM.emp_no;




