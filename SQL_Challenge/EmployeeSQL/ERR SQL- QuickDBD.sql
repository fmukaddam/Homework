-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "Employees" (
    "employee_no" INT   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" VARCHAR(100)   NOT NULL,
    "last_name" VARCHAR(100)   NOT NULL,
    "gender" VARCHAR(10)   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "employee_no"
     )
);

CREATE TABLE "Departments" (
    "dept_no" VARCHAR(100)   NOT NULL,
    "dept_name" VARCHAR(100)   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "Salaries" (
    "employee_no" INT   NOT NULL,
    "salary" money   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

CREATE TABLE "Dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "employee_no" INT   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

CREATE TABLE "Dept_employee" (
    "dept_no" VARCHAR   NOT NULL,
    "employee_no" INT   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

CREATE TABLE "Titles" (
    "employee_no" INT   NOT NULL,
    "title" VARCHAR(100)   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

ALTER TABLE "Salaries" ADD CONSTRAINT "fk_Salaries_employee_no" FOREIGN KEY("employee_no")
REFERENCES "Employees" ("employee_no");

ALTER TABLE "Dept_manager" ADD CONSTRAINT "fk_Dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Dept_manager" ADD CONSTRAINT "fk_Dept_manager_employee_no" FOREIGN KEY("employee_no")
REFERENCES "Employees" ("employee_no");

ALTER TABLE "Dept_employee" ADD CONSTRAINT "fk_Dept_employee_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Dept_employee" ADD CONSTRAINT "fk_Dept_employee_employee_no" FOREIGN KEY("employee_no")
REFERENCES "Employees" ("employee_no");

ALTER TABLE "Titles" ADD CONSTRAINT "fk_Titles_employee_no" FOREIGN KEY("employee_no")
REFERENCES "Employees" ("employee_no");

