# 1. Создание простого View: Напишите SQL-запрос для создания представления (View), которое отображает имена и фамилии всех сотрудников.
CREATE VIEW v_employee_names AS
SELECT first_name, last_name FROM employees;
SELECT * FROM v_employee_names;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2. View с JOIN: Создайте представление, которое объединяет таблицы employees и salaries, показывая идентификатор сотрудника, его имя, фамилию и текущую зарплату.
CREATE VIEW v_employee_current_salary AS
SELECT E.emp_no, E.first_name, E.last_name, S.salary FROM employees E
JOIN salaries S
ON E.emp_no = S.emp_no
WHERE to_date = '9999-01-01';
SELECT * FROM v_employee_current_salary;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 3. View для агрегированных данных: Создайте представление, которое показывает среднюю зарплату по каждому отделу.
CREATE VIEW v_department_avg_salary AS
SELECT DE.Dept_no, ROUND(AVG(S.salary), 2 ) AS AVG_salary , D.dept_name AS Department FROM salaries S
JOIN dept_emp DE
ON S.emp_no = DE.emp_no
JOIN departments D
ON D.dept_no = DE.dept_no
WHERE S.to_date = '9999-01-01'
GROUP BY DE.Dept_no
ORDER BY DE.dept_no;
SELECT * FROM v_department_avg_salary;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 4. Комбинированный View с JOIN и WHERE: Создайте представление, которое отображает информацию о сотрудниках, работающих в отделе 'Sales'
CREATE VIEW v_sales_department_employees AS
SELECT E.emp_no, E.first_name, E.last_name, E.birth_date, E.gender, E.hire_date, S.salary FROM employees E
JOIN dept_emp DE
ON E.emp_no = DE.emp_no
JOIN departments D
ON DE.dept_no = D.dept_no
JOIN salaries S
ON E.emp_no = S.emp_no
WHERE D.dept_name = 'Sales' AND DE.to_date > CURDATE() AND S.to_date > curdate();
SELECT * FROM v_sales_department_employees;