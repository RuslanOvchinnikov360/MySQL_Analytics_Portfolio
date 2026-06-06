# 1. Найдите всех сотрудников, которые работали как минимум в 2 департаментах. Вывести их имя и фамилию. Показать записи в порядке возрастания.
SELECT first_name, last_name FROM employees
WHERE emp_no IN (SELECT emp_no FROM dept_emp GROUP BY emp_no HAVING COUNT(DISTINCT dept_no) > 1)
ORDER BY first_name, last_name;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 2. Вывести имя, фамилию и зарплату самого высокооплачиваемого сотрудника.
# SELECT * FROM employees
# WHERE emp_no IN (SELECT emp_no FROM salaries ORDER BY salary DESC LIMIT 1); <----- Зпрос не сработал, ограничения MySQL, ниже пробую через JOIN

SELECT E.first_name, E.last_name
FROM employees E
JOIN salaries S ON E.emp_no = S.emp_no
WHERE S.salary IN (SELECT MAX(salary) FROM salaries);
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 3. Создайте запрос, который выбирает названия всех отделов, в которых работает более 100 сотрудников.
SELECT dept_name FROM departments
WHERE dept_no IN (SELECT dept_no FROM dept_emp WHERE to_date > CURDATE() GROUP BY dept_no HAVING COUNT(*) > 100);

# Попробовал через JOIN но фильтрация не произошла, или действительно нет таких департаментов и везде больше ста
SELECT D.dept_name, COUNT(*) AS employee_count
FROM dept_emp DE
JOIN departments D
ON DE.dept_no = D.dept_no
WHERE DE.to_date > CURDATE()
GROUP BY D.dept_no, D.dept_name
HAVING COUNT(*) > 100;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 4. Напишите запрос, который находит имена и фамилии всех сотрудников, которые никогда не были менеджерами.
SELECT first_name, last_name FROM employees
WHERE emp_no NOT IN (SELECT emp_no FROM dept_manager);

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 5. Создайте запрос, который для каждого отдела выводит сотрудников, получающих наибольшую зарплату в этом отделе.

DROP TEMPORARY TABLE IF EXISTS DEPT_MAX_Salary;
CREATE TEMPORARY TABLE DEPT_MAX_Salary
SELECT DE.dept_no, MAX(S.salary) AS MAX_salary FROM salaries S
JOIN dept_emp DE
ON S.emp_no = DE.emp_no
GROUP BY DE.dept_no;
SELECT DMS.dept_no, DE.emp_no, S.salary FROM DEPT_MAX_Salary DMS
JOIN dept_emp DE ON DMS.dept_no = DE.dept_no
JOIN salaries S ON S.emp_no = DE.emp_no AND S.salary = DMS.MAX_salary;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 6. Напишите запрос, который выбирает названия отделов, где средняя зарплата выше общей средней зарплаты по компании.
SELECT DE.dept_no, AVG(S.salary) AS DAS FROM salaries S
JOIN dept_emp DE
ON S.emp_no = DE.emp_no
GROUP BY DE.dept_no
HAVING DAS > (SELECT AVG(salary) FROM salaries);



