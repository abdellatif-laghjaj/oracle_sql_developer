-- 1.  What are three uses for a view from a DBA’s perspective?
-- ·         Restrict access and display selective columns
-- ·         Reduce complexity of queries from other internal systems. So, providing a way to view same data in a different manner.
-- ·         Let the app code rely on views and allow the internal implementation of tables to be modified later.
-- 2.  Create a simple view called view_d_songs that contains the ID, title, and artist from the DJs on Demand table for each “New Age” type code. In the subquery, use the alias “Song Title” for the title column.
-- The subquery:

SELECT d_songs.id, d_songs.title "Song Title", d_songs.artist
from d_songs INNER JOIN d_types ON d_songs.type_code = d_types.code
where d_types.description = 'New Age';
Now the view:
CREATE VIEW view_d_songs AS
SELECT d_songs.id, d_songs.title "Song Title", d_songs.artist
from d_songs INNER JOIN d_types ON d_songs.type_code = d_types.code
where d_types.description = 'New Age';

CREATE OR REPLACE VIEW view_d_songs AS
SELECT d_songs.id, d_songs.title "Song Title", d_songs.artist
from d_songs INNER JOIN d_types ON d_songs.type_code = d_types.code
where d_types.description = 'New Age';

-- Verify results again:
SELECT * FROM view_d_songs ;

-- 3.
SELECT *
FROM view_d_songs.
-- What was returned?
-- The result is same as that of
SELECT d_songs.id, d_songs.title "Song Title", d_songs.artist
from d_songs INNER JOIN d_types ON d_songs.type_code = d_types.code
where d_types.description = 'New Age';

SELECT * FROM view_d_songs ;

-- 4.  REPLACE view_d_songs. Add type_code to the column list. Use aliases for all columns.
CREATE OR REPLACE VIEW view_d_songs AS
SELECT d_songs.id, d_songs.title "Song Title", d_songs.artist, d_songs.type_code
from d_songs INNER JOIN d_types ON d_songs.type_code = d_types.code
where d_types.description = 'New Age';

-- 5.  Jason Tsang, the disk jockey for DJs on Demand, needs a list of the past events and those planned for the coming months so he can make arrangements for each event’s equipment setup. As the company manager, you do not want him to have access to the price that clients paid for their events. Create a view for Jason to use that displays the name of the event, the event date, and the theme description. Use aliases for each column name.
CREATE OR REPLACE VIEW view_d_events_pkgs AS
SELECT evt.name "Name of Event", TO_CHAR(evt.event_date, 'dd-Month-yyyy')  "Event date", thm.description "Theme description"
FROM  d_events  evt INNER JOIN d_themes  thm  ON evt.theme_code = thm.code
WHERE evt.event_date <= ADD_MONTHS(SYSDATE,1);
SELECT * FROM view_d_events_pkgs ;

-- 6.  It is company policy that only upper-level management be allowed access to individual employee salaries. The department managers, however, need to know the minimum, maximum, and average salaries, grouped by department. Use the Oracle database to prepare a view that displays the needed information for department managers.
DESC employees;
-- suggests:
-- Salary is a nullable field, I don't want to miss nulls in average/min/max calculation.
-- There may be some employees without department mentioned since it is nullable. I want to miss such records in my calculations.
-- SELECT department_id FROM departments WHERE department_id NOT IN ( SELECT NVL(department_id,0) FROM employees);
-- Suggests:
-- There may be a department for which there is no record in employees table.

CREATE OR REPLACE VIEW view_min_max_avg_dpt_salary ("Department Id", "Department Name", "Max Salary", "Min Salary", "Average Salary") AS
SELECT dpt.department_id, dpt.department_name, MAX(NVL(emp.salary,0)), MIN(NVL(emp.salary,0)), ROUND(AVG(NVL(emp.salary,0)),2)
FROM departments dpt LEFT OUTER JOIN employees emp ON dpt.department_id = emp.department_id
GROUP BY (dpt.department_id, dpt.department_name);

SELECT * FROM view_min_max_avg_dpt_salary;