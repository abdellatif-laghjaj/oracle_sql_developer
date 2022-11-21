
-- Use the DESCRIBE statement to verify that you have tables named copy_d_songs, copy_d_events, copy_d_cds, and copy_d_clients in your schema. If you don't, write a query to create a copy of each.
CREATE TABLE copy_d_songs
AS ( SELECT * FROM d_songs);
DESCRIBE copy_d_songs;
DESCRIBE d_songs;
SELECT * FROM d_songs;
SELECT * FROM copy_d_songs;


CREATE TABLE copy_d_events
AS ( SELECT * FROM d_events);
DESCRIBE copy_d_events ;
DESCRIBE d_events;
SELECT * FROM d_events ;
SELECT * FROM copy_d_events ;


CREATE TABLE copy_d_cds
AS ( SELECT * FROM d_cds);
DESCRIBE copy_d_cds;
DESCRIBE d_cds;
SELECT * FROM d_cds;
SELECT * FROM copy_d_cds ;


CREATE TABLE copy_d_clients
AS ( SELECT * FROM d_clients);
DESC copy_d_clients ;
DESC d_clients;
SELECT * FROM d_clients ;
SELECT * FROM copy_d_clients ;

-- 1. Query the data dictionary USER_UPDATABLE_COLUMNS to make sure the columns in the base tables will allow UPDATE, INSERT, or DELETE. Use a SELECT statement or the Browse Data Dictionary feature in HTML DB. All table names in the data dictionary are stored in uppercase.
-- USER_UPDATABLE_COLUMNS describes columns in a join view that can be updated by the current user, subject to appropriate privileges.

SELECT owner, table_name, column_name, updatable,insertable, deletable
FROM user_updatable_columns WHERE LOWER(table_name) = 'copy_d_songs';

SELECT owner, table_name, column_name, updatable,insertable, deletable
FROM user_updatable_columns WHERE LOWER(table_name) = 'copy_d_events';


SELECT owner, table_name, column_name, updatable,insertable, deletable
FROM user_updatable_columns WHERE LOWER(table_name) = 'copy_d_cds';

SELECT owner, table_name, column_name, updatable,insertable, deletable
FROM user_updatable_columns WHERE LOWER(table_name) = 'copy_d_clients';

-- 2.  Use the CREATE or REPLACE option to create a view of all the columns in the copy_d_songs table called view_copy_d_songs.

CREATE OR REPLACE VIEW view_copy_d_songs  AS
SELECT *
FROM copy_d_songs;

SELECT * FROM view_copy_d_songs;

-- 3.  Use view_copy_d_songs to INSERT the following data into the underlying copy_d_songs table. Execute a SELECT * from copy_d_songs to verify your DML command

INSERT INTO view_copy_d_songs(id,title,duration,artist,type_code)
VALUES(88,'Mello Jello','2 min','The What',4);

-- 4.  Create a view based on the DJs on Demand COPY_D_CDS table. Name the view read_copy_d_cds. Select all columns to be included in the view. Add a WHERE clause to restrict the year to 2000. Add the WITH READ ONLY option.

CREATE OR REPLACE VIEW read_copy_d_cds  AS
SELECT *
FROM copy_d_cds
WHERE year = '2000'
WITH READ ONLY ;

SELECT * FROM read_copy_d_cds;

-- 5.  Using the read_copy_d_cds view, execute a DELETE FROM read_copy_d_cds WHERE cd_number = 90;
-- ORA-42399: cannot perform a DML operation on a read-only view

6.  Use REPLACE to modify read_copy_d_cds. Replace the READ ONLY option with WITH CHECK OPTION CONSTRAINT ck_read_copy_d_cds. Execute a SELECT * statement to verify that the view exists.
CREATE OR REPLACE VIEW read_copy_d_cds  AS
SELECT *
FROM copy_d_cds
WHERE year = '2000'
WITH CHECK OPTION CONSTRAINT ck_read_copy_d_cds;

-- 7.  Use the read_copy_d_cds view to delete any CD of year 2000 from the underlying copy_d_cds.
DELETE FROM read_copy_d_cds
WHERE year = '2000';

-- 8.  Use the read_copy_d_cds view to delete cd_number 90 from the underlying copy_d_cds table.

DELETE FROM read_copy_d_cds
WHERE cd_number = 90;

-- 9.  Use the read_copy_d_cds view to delete year 2001 records.

DELETE FROM read_copy_d_cds
WHERE year = '2001';

-- 10. Execute a SELECT * statement for the base table copy_d_cds. What rows were deleted?

-- Only the one in problem 7 above, not the one in 8 and 9