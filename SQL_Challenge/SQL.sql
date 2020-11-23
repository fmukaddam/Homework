CREATE TABLE departments (
    dept_no VARCHAR(20) PRIMARY KEY NOT NULL,
    dept_name VARCHAR(30));

CREATE TABLE titles (
    emp_title_id VARCHAR(20) PRIMARY KEY NOT NULL,
    title VARCHAR(30) NOT NULL
);

CREATE TABLE employees (
    employee_no INT PRIMARY KEY NOT NULL,
    emp_title_id VARCHAR(10) NOT NULL,
	FOREIGN KEY (emp_title_id) REFERENCES titles(emp_title_id),
    birth_date DATE NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    sex VARCHAR(2) NOT NULL,
    hire_date DATE  NOT NULL
);

CREATE TABLE dept_employee (
    employee_no INT,
	dept_no VARCHAR(100),
	FOREIGN KEY (employee_no) REFERENCES employees (employee_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no));

CREATE TABLE dept_manager (
    dept_no VARCHAR(100),
    employee_no INT,
	FOREIGN KEY (employee_no) REFERENCES employees (employee_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no));
	

CREATE TABLE salaries (
    employee_no INT,
    salary MONEY,
	FOREIGN KEY (employee_no) REFERENCES employees (employee_no));
	
SELECT * FROM departments
SELECT * FROM titles
SELECT * FROM employees
SELECT * FROM dept_employee
SELECT * FROM dept_manager
SELECT * FROM salaries


--1) List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT a.employee_no, a.last_name, a.first_name, a.sex, b.salary
FROM employees a
JOIN salaries b
on a.employee_no = b.employee_no;

--2) List first name, last name, and hire date for employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1987-01-01'
ORDER BY hire_date;

--3) List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, first name.
SELECT a.dept_no, a.dept_name, b.employee_no, c.last_name, c.first_name
FROM departments a
JOIN dept_manager b
ON a.dept_no = b.dept_no
JOIN employees c
ON b.employee_no = c.employee_no;

--4) List the department of each employee with the following information: 
--employee number, last name, first name, and department name.
SELECT a.employee_no, b.last_name, b.first_name, c.dept_name
FROM dept_employee a
JOIN employees b
ON a.employee_no = b.employee_no
JOIN departments c
ON b.dept_no = c.dept_no;

--5)List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'

--6)List all employees in the Sales department, 
--including their employee number, last name, first name, and department name.
SELECT a.employee_no, b.last_name, b.first_name, c.dept_name
FROM dept_employee a
JOIN employees b
ON a.employee_no = b.employee_no
JOIN departments c
ON a.dept_no = c.dept_no
WHERE dept_name = 'Sales'

--7)List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.
SELECT a.employee_no, b.last_name, b.first_name, c.dept_name
FROM dept_employee a
JOIN employees b
ON a.employee_no = b.employee_no
JOIN departments c
ON a.dept_no = c.dept_no
WHERE c.dept_name = 'Sales'
OR c.dept_name = 'Development'

--8)In descending order, list the frequency count of employee last names, 
--i.e., how many employees share each last name.
SELECT last_name
	,count(last_name) as "frequency"
	FROM employees
	GROUP BY last_name
	ORDER BY "frequency" DESC
