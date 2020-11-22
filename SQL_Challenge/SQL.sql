CREATE TABLE employees (
    employee_no INT PRIMARY KEY NOT NULL,
	employee_title_id VARCHAR(100),
    birth_date DATE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    gender VARCHAR(100),
    hire_date DATE);

CREATE TABLE departments (
    dept_no VARCHAR(100) PRIMARY KEY NOT NULL,
    dept_name VARCHAR(100));

CREATE TABLE salaries (
    employee_no INT,
    salary MONEY,
    from_date DATE,
    to_date DATE,
	FOREIGN KEY (employee_no) REFERENCES employees (employee_no));

CREATE TABLE dept_manager (
    dept_no VARCHAR(100),
    employee_no INT,
    from_date DATE,
    to_date DATE,
	PRIMARY KEY (dept_no,employee_no));


CREATE TABLE dept_employee (
    employee_no INT,
	dept_no VARCHAR(100),
	PRIMARY KEY (dept_no,employee_no));

CREATE TABLE titles (
    employee_no int NOT NULL,
    title VARCHAR,
    from_date DATE,
    to_date DATE,  
	FOREIGN KEY (employee_no) REFERENCES employees (employee_no)
);

DROP TABLE employees
DROP TABLE salaries
DROP TABLE titles
DROP TABLE dept_employee