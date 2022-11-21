-- 1.  What is an index and what is it used for?
-- Definition: These are schema objects which make retrieval of rows from table faster.
-- - They are meant to be efficient way to find data in database. I may like to drop an index if, queries in application are not using some index or say it is not speeding up the queries or may be table is very small. An index provides direct and fast access to row in table.
-- ·         I should create an index if the table is large and most queries are expected to retrieve less than 2 to 4 percent of the rows.
-- ·         I should create an index if one or more columns are frequently used together in a join condition.
-- Purpose: An index provides direct and fast access to row in table. They provide indexed path to locate data quickly, so hereby reduce necessity of heavy disk input/output operations.
-- Track usage of index:

-- Look into what indexes employees table has:
SELECT ucm.index_name, ucm.column_name, ucm.column_position, uix.uniqueness
FROM user_indexes uix INNER JOIN user_ind_columns ucm ON uix.index_name = ucm.index_name
WHERE ucm.table_name = 'EMPLOYEES';

-- Start monitoring an index:
ALTER INDEX emp_id_pk MONITORING USAGE;

-- Note down column values in V$OBJECT_USAGE:
SELECT * FROM v$object_usage WHERE index_name = 'EMP_ID_PK';

-- Run a statement which may be using the index:
SELECT * from employees where employee_id = 100;

-- Note down column values in V$OBJECT_USAGE:
SELECT * FROM v$object_usage WHERE index_name = 'EMP_ID_PK';

-- Stop monitoring an index:
ALTER INDEX emp_id_pk NOMONITORING USAGE;

-- 2.  What is a ROWID, and how is it used?
-- Indexes use ROWID's (base 64 string representation of the row address containing block identifier,
-- row location in the block and the database file identifier) which is the fastest way to access any particular row.


-- 3.  When will an index be created automatically?

-- For primary/unique keys: Although unique index can   be created manually, but preferred should be by using unique/primary constraint in the table. So, it   means that primary key/unique key use already existing unique index but if index is not present already, it is created while applying unique/primary key constraint.
-- Oracle also creates index automatically for LOB storage, xmltype and materialized view.

-- 4.  Create a nonunique index (foreign key) for the DJs on Demand column (cd_number) in the D_TRACK_LISTINGS table. Use the Oracle Application Developer SQL Workshop Data Browser to confirm that the index was created.
-- Creating index (non-unique):

CREATE INDEX d_tlg_cd_number_fk_i
on d_track_listings (cd_number);

-- Verify by SQL statement:
SELECT ucm.index_name, ucm.column_name, ucm.column_position, uix.uniqueness
FROM user_indexes uix INNER JOIN user_ind_columns ucm ON uix.index_name = ucm.index_name
WHERE ucm.table_name = 'D_TRACK_LISTINGS' AND column_name = 'CD_NUMBER';

-- 5.  Use the join statement to display the indexes and uniqueness that exist in the data dictionary for the DJs on Demand D_SONGS table.
SELECT ucm.index_name, ucm.column_name, ucm.column_position, uix.uniqueness
FROM user_indexes uix INNER JOIN user_ind_columns ucm ON uix.index_name = ucm.index_name
WHERE ucm.table_name = 'D_SONGS';


-- 6.  Use a SELECT statement to display the index_name, table_name, and uniqueness from the data dictionary USER_INDEXES for the DJs on Demand D_EVENTS table.
SELECT index_name, table_name,uniqueness  FROM user_indexes  where table_name = 'D_EVENTS';


-- 7.  Write a query to create a synonym called dj_tracks for the DJs on Demand d_track_listings table.
CREATE PUBLIC SYNONYM dj_tracks FOR d_track_listings;
-- ORA-01031: insufficient privileges

-- 8.  Create a function-based index for the last_name column in DJs on Demand D_PARTNERS table that makes it possible not
-- to have to capitalize the table name for searches. Write a SELECT statement that would use this index.
-- Read this as last_name
-- What All indexes this table has right now:
SELECT ucm.index_name, ucm.column_name, ucm.column_position, uix.uniqueness
FROM user_indexes uix INNER JOIN user_ind_columns ucm ON uix.index_name = ucm.index_name
WHERE ucm.table_name = 'D_PARTNERS';

-- Create index:
CREATE INDEX d_ptr_last_name_idx
ON d_partners(LOWER(last_name));

-- Start monitoring an index:
ALTER INDEX d_ptr_last_name_idx MONITORING USAGE;

-- Note down column values in V$OBJECT_USAGE:
SELECT * FROM v$object_usage WHERE index_name = 'D_PTR_LAST_NAME_IDX';

-- Run a statement which may be using the index:
SELECT *
FROM d_partners
WHERE LOWER(last_name) = 'something';

-- Note down column values in V$OBJECT_USAGE:
SELECT * FROM v$object_usage WHERE index_name = 'D_PTR_LAST_NAME_IDX';

-- Stop monitoring an index:
ALTER INDEX d_ptr_last_name_idx NOMONITORING USAGE;