-- 1.  Create a view from the copy_d_songs table called view_copy_d_songs that includes only the title and artist. Execute a SELECT * statement to verify that the view exists.
CREATE OR REPLACE VIEW view_copy_d_songs  AS
SELECT title, artist
FROM copy_d_songs;

SELECT * FROM view_copy_d_songs;

-- 2.  Issue a DROP view_copy_d_songs. Execute a SELECT * statement to verify that the view has been deleted.

DROP VIEW view_copy_d_songs;
SELECT * FROM view_copy_d_songs;
-- ORA-00942: table or view does not exist

-- 3.  Create a query that selects the last name and salary from the Oracle database. Rank the salaries from highest to lowest for the top three employees.
SELECT * FROM
(SELECT last_name, salary FROM employees ORDER BY salary  DESC)
WHERE ROWNUM <= 3;

-- 4.  Construct an inline view from the Oracle database that lists the last name, salary, department ID, and maximum salary for each department. Hint: One query will need to calculate maximum salary by department ID.
-- There may be some employees without department mentioned since it is nullable. I want to miss such records in my calculations. This is achieved in dptmx in-line view itself. Also a department without an employee is also taken in.

SELECT empm.last_name, empm.salary, dptmx.department_id
FROM
(SELECT dpt.department_id, MAX(NVL(emp.salary,0)) max_dpt_sal
FROM departments dpt LEFT OUTER JOIN employees emp ON dpt.department_id = emp.department_id
GROUP BY dpt.department_id) dptmx LEFT OUTER JOIN employees empm ON dptmx.department_id = empm.department_id
WHERE NVL(empm.salary,0) = dptmx.max_dpt_sal;

-- 5.  Create a query that will return the staff members of Global Fast Foods ranked by salary from lowest to highest.
SELECT ROWNUM,last_name, salary
FROM
(SELECT * FROM f_staffs ORDER BY SALARY);


-- Extras:
-- 1.  Create a new table called my_departments and add all columns and all rows to it using a subquery from the Oracle departments table. Do a SELECT * from my_departments to confirm that you have all the columns and rows.
CREATE TABLE my_departments
AS ( SELECT * FROM departments);
DESCRIBE my_departments;
DESCRIBE departments;
SELECT * FROM departments;
SELECT * FROM my_departments;

-- 2.  To view any constraints that may affect the my_departments table, DESCRIBE my_departments to check if any constraints were carried over from the departments table. If there are constraints on my_departments, use an ALTER TABLE command to DISABLE all constraints on my_departments.
-- Foreign key, check and primary key don’t go with copy but not NULL check constraint goes in copy:
DESC my_departments;

SELECT * FROM user_constraints WHERE table_name = UPPER('my_departments');

ALTER TABLE my_departments
DROP CONSTRAINT SYS_C00868380;

-- 3.  Create a view called view_my_departments that includes: department_id and department_name.
CREATE OR REPLACE VIEW view_my_departments  AS
SELECT department_id , department_name
FROM my_departments;
SELECT * FROM view_my_departments ;

-- 4.  Add the following data to the my_departments table using view_my_departments.

-- I verified that I can't include here: manager_id, location_id: ORA-00904: column_name: invalid identifier
INSERT INTO view_my_departments ( department_id, department_name)
VALUES(105, 'Advertising');
INSERT INTO view_my_departments ( department_id, department_name)
VALUES(120, 'Custodial');
INSERT INTO view_my_departments ( department_id, department_name)
VALUES(130, 'Planning');
SELECT * FROM my_departments;

-- 5.  Create or enable the department_id column as the primary key.

ALTER TABLE my_departments
ADD CONSTRAINT my_departments_id_pk  PRIMARY KEY (department_id);
DESC my_departments;

-- 6.  Enter a new department named Human Resources into the my_departments table using view_my_departments. Do not add a new department ID.
INSERT INTO view_my_departments ( department_id, department_name)
VALUES(NULL, 'Human Resources');
-- ORA-01400: cannot insert NULL into ("HKUMAR"."MY_DEPARTMENTS"."DEPARTMENT_ID")
INSERT INTO view_my_departments ( department_id, department_name)
VALUES(105, 'Human Resources');
-- ORA-00001: unique constraint (HKUMAR.MY_DEPARTMENTS_ID_PK) violated

-- 7.  Add the Human Resources department, department ID 220, to my_departments using view_my_departments.
INSERT INTO view_my_departments ( department_id, department_name)
VALUES(220, 'Human Resources');

SELECT * FROM my_departments;


-- 9.  Modify view_my_departments to include location ID. Do a SELECT * command to show what columns are present and a DESCRIBE command to view the columns and associated constraints.
CREATE OR REPLACE VIEW view_my_departments  AS
SELECT department_id , department_name, location_id
FROM my_departments;

SELECT * FROM view_my_departments ;
SELECT department_id , department_name, location_id
FROM my_departments;

DESC view_my_departments;
DESC my_departments;

SELECT * FROM user_constraints WHERE table_name = UPPER('view_my_departments');
SELECT * FROM user_constraints WHERE table_name = UPPER('my_departments');