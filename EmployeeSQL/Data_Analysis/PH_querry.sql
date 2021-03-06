--Questions and Querrys :
---------------------------
-- 1: List the following details of each employee: employee number, last name, first name, sex, and salary.
-- Select 'employees' in ascending order
SELECT * FROM employees 
ORDER BY emp_no;

-- Select 'salary' table
SELECT * FROM salary ;

-- Querry using Inner join to access the columns from both the tables
SELECT e.emp_no as id, e.last_name , e.first_name , e.sex , s.salary
FROM employees e
JOIN salary s USING(emp_no) 
ORDER BY emp_no; 


-- 2. List first name, last name, and hire date for employees who were hired in 1986.

-- Cast VARCHAR "hire_date" format to date (YYYY-MM-DD) format
ALTER TABLE employees 
ALTER COLUMN hire_date TYPE DATE USING to_date(hire_date, 'MM/DD/YYYY')

-- Selecting employees hired in 1986
SELECT first_name , last_name , hire_date
FROM employees
WHERE hire_date BETWEEN '1986/1/1' AND '1986/12/31'
ORDER BY hire_date; 


-- 3. List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, first name.

-- select the department table
SELECT * FROM department;

--Select the mangagers in all the department
SELECT * FROM dept_manager;

-- select the employees table for their names
SELECT * FROM employees;

--Inner join to select the required columns
SELECT dt.dept_no , d.dept_name, dt.emp_no, e.last_name , e.first_name 
FROM department d
INNER JOIN dept_manager dt USING(dept_no)
INNER JOIN employees e USING(emp_no)

--Create a CTE to ensure results are same (debugging)
-- can be used for debugging
WITH mgr AS (SELECT emp_no ,  last_name , first_name
			 FROM employees 
             WHERE emp_no IN (SELECT  emp_no FROM dept_manager) ) , dept as (SELECT dm.dept_no , d.dept_name , dm.emp_no
																			 FROM department d, dept_manager dm 
																			 WHERE d.dept_no = dm.dept_no)
SELECT dept.dept_no , dept.dept_name, mgr.emp_no,  mgr.last_name ,mgr.first_name
FROM mgr , dept
WHERE mgr.emp_no = dept.emp_no ;

-- 4. List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.
	 
-- Select dept_emp table for the department number
SELECT * FROM dept_emp

-- Select employs and their department names
SELECT e.emp_no , e.last_name , e.first_name , d.dept_no
FROM employees e , dept_emp d
WHERE e.emp_no = d.emp_no 
ORDER BY e.emp_no ;

-- 5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name , last_name , sex
FROM employees 
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.

-- Select tables for the filtering
SELECT * FROM dept_emp
SELECT * FROM employees;
SELECT * FROM department;

-- Createa  view table to select sales department and fetch its dept_no and name
CREATE VIEW sales AS (SELECT dept_no, dept_name FROM department
					  WHERE dept_name = 'Sales') ;
--display sales department name and no.
SELECT * FROM sales;

-- create a view table to select emp_no form the sales department
CREATE VIEW sales_dept AS (SELECT emp_no FROM dept_emp
						   WHERE dept_no IN (SELECT dept_no FROM sales));
--display sales department name and no.
SELECT * FROM sales_dept;

--Select emplpyee details using the view tables sales and sales_dept
SELECT e.emp_no , e.last_name , e.first_name , s.dept_name
FROM employees e , sales s , sales_dept sd
WHERE e.emp_no = sd.emp_no
ORDER BY e.emp_no;

-- Drop view tables if not needed
--DROP VIEW sales ;
--DROP VIEW sales_dept ;

--7. List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.

-- create a view table for both sales and development
CREATE VIEW sales_development AS (SELECT dept_no, dept_name FROM department
					  			  WHERE dept_name = 'Sales' OR dept_name = 'Development') ;
--display sales_development department name and no.
SELECT * FROM sales_development;

-- create a view table to select emp_no form the sales department
CREATE VIEW sales_dev_dept AS (SELECT emp_no FROM dept_emp
						   	   WHERE dept_no IN (SELECT dept_no FROM sales_development));
--display sales department name and no.
SELECT * FROM sales_dev_dept
ORDER BY emp_no ;

--Select emplpyee details using the view tables sales_development and sales_dev_dept
SELECT e.emp_no , e.last_name , e.first_name , sd.dept_name
FROM employees e , sales_development sd 
WHERE e.emp_no IN (SELECT emp_no FROM sales_dev_dept)
ORDER BY e.emp_no ;

-- Drop view tables if not needed
--DROP VIEW sales_development ;
--DROP VIEW sales_dev_dept ;

--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

--count last_names grouped by last name from the employee table
SELECT last_name , count(last_name) "last_name Total" FROM employees
GROUP BY last_name
ORDER BY "last_name Total" DESC;

