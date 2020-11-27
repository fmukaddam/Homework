-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/WutXrb
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "Employees" (
    "employee_no" INT   NOT NULL,
    "emp_title_id" VARCHAR(10)   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(20)   NOT NULL,
    "last_name" VARCHAR(20)   NOT NULL,
    "gender" VARCHAR(2)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "employee_no"
     )
);

CREATE TABLE "Titles" (
    "emp_title_id" VARCHAR(10)   NOT NULL,
    "title" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_Titles" PRIMARY KEY (
        "emp_title_id"
     )
);

CREATE TABLE "Departments" (
    "dept_no" VARCHAR(20)   NOT NULL,
    "dept_name" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "Dept_employee" (
    "employee_no" INT   NOT NULL,
    "dept_no" VARCHAR(100)   NOT NULL
);

CREATE TABLE "Dept_manager" (
    "employee_no" INT   NOT NULL,
    "dept_no" VARCHAR(100)   NOT NULL
);

CREATE TABLE "Salaries" (
    "employee_no" INT   NOT NULL,
    "salary" MONEY   NOT NULL,
    CONSTRAINT "pk_Salaries" PRIMARY KEY (
        "employee_no"
     )
);

ALTER TABLE "Employees" ADD CONSTRAINT "fk_Employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "Titles" ("emp_title_id");

ALTER TABLE "Dept_employee" ADD CONSTRAINT "fk_Dept_employee_employee_no" FOREIGN KEY("employee_no")
REFERENCES "Employees" ("employee_no");

ALTER TABLE "Dept_employee" ADD CONSTRAINT "fk_Dept_employee_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Dept_manager" ADD CONSTRAINT "fk_Dept_manager_employee_no" FOREIGN KEY("employee_no")
REFERENCES "Employees" ("employee_no");

ALTER TABLE "Dept_manager" ADD CONSTRAINT "fk_Dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Salaries" ADD CONSTRAINT "fk_Salaries_employee_no" FOREIGN KEY("employee_no")
REFERENCES "Employees" ("employee_no");

