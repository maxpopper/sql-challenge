drop table departments;
drop table dept_emp;
drop table dept_manager;
drop table employees;
drop table salaries;
drop table titles;


select * from departments;
select * from dept_emp;
select * from dept_manager;
select * from employees;
select * from salaries;
select * from titles;


CREATE TABLE departments (
    dept_no varchar   NOT NULL,
    dept_name varchar   NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (
        dept_no
     )
);

CREATE TABLE dept_emp (
    emp_no int   NOT NULL,
    dept_no varchar   NOT NULL
);

CREATE TABLE dept_manager (
    dept_no varchar   NOT NULL,
    emp_no int   NOT NULL
);

CREATE TABLE employees (
    emp_no int   NOT NULL,
    emp_title_id varchar   NOT NULL,
    birth_date varchar   NOT NULL,
    first_name varchar   NOT NULL,
    last_name varchar   NOT NULL,
    sex varchar   NOT NULL,
    hire_date varchar   NOT NULL,
	CONSTRAINT pk_employees PRIMARY KEY (
        emp_no
     )
);

UPDATE employees
SET birth_date = TO_DATE(birth_date, 'MM/DD/YYYY'),
	hire_date = TO_DATE(hire_date, 'MM/DD/YYYY');

ALTER TABLE employees
ALTER COLUMN birth_date TYPE DATE USING birth_date::DATE;

ALTER TABLE employees
ALTER COLUMN hire_date TYPE DATE USING hire_date::DATE;

CREATE TABLE salaries (
    emp_no int   NOT NULL,
    salary int   NOT NULL
);

CREATE TABLE titles (
    title_id varchar   NOT NULL,
    title varchar   NOT NULL,
    CONSTRAINT pk_titles PRIMARY KEY (
        title_id
     )
);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE employees ADD CONSTRAINT fk_employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES titles (title_id);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);


-- 1) List the emp_no, last_name, first_name, sex, and salary of each employee 
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees as e
INNER JOIN salaries as s ON
s.emp_no = e.emp_no;

-- 2) List the first_name, last_name, and hire_date for the employees who were hired in 1986
SELECT first_name, last_name, hire_date FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

-- 3) List the manager of each dept along with their dept_no, dept_name, emp_no, last_name, and first_name
SELECT dm.dept_no,
		dm.emp_no,
		d.dept_name,
		e.last_name,
		e.first_name
FROM dept_manager as dm
INNER JOIN departments as d ON
d.dept_no = dm.dept_no
INNER JOIN employees as e ON
e.emp_no = dm.emp_no;

-- 4) List the dept_no for each employee along with that employee’s emp_no, last_name, first_name, and dept_name
SELECT de.dept_no, 
		de.emp_no, 
		e.last_name,
		e.first_name,
		d.dept_name
FROM dept_emp as de
INNER JOIN employees as e ON
e.emp_no = de.emp_no
INNER JOIN departments as d ON
d.dept_no = de.dept_no;

-- 5) List first_name, last_name, and sex of each employee whose first name is Hercules 
-- and whose last name begins with the letter B
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules'
GROUP BY first_name, last_name, sex
HAVING last_name LIKE 'B%'

-- 6) List each employee in the Sales department, including their emp_no, last_name, and first_name
SELECT d.dept_name, 
		de.emp_no, 
		e.last_name, 
		e.first_name
FROM dept_emp as de
INNER JOIN departments as d ON
d.dept_no = de.dept_no
INNER JOIN employees as e ON
e.emp_no = de.emp_no
WHERE d.dept_name = 'Sales';

-- 7) List each employee in the Sales and Development departments 
-- including their emp_no, last_name, first_name, and dept_name
SELECT de.emp_no, 
		e.last_name, 
		e.first_name,
		d.dept_name
FROM dept_emp as de
INNER JOIN departments as d ON
d.dept_no = de.dept_no
INNER JOIN employees as e ON
e.emp_no = de.emp_no
WHERE d.dept_name IN ('Sales', 'Development');

-- 8) List the frequency counts, in descending order, of all the employee last names 
-- (that is, how many employees share each last name)

SELECT last_name, COUNT(last_name) as "last_name count"
FROM employees
GROUP BY last_name
ORDER BY "last_name count" DESC
