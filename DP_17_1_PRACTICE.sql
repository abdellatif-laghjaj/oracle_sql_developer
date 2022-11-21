-- 1
-- .What are system privileges concerned with?
-- .System privileges determine what the user can do at the DB level. They are concerned with right to perform a particular action or to perform an action on any object (tables, views, materialized views, synonyms, indexes, sequences, cache groups, replication schemes and PL/SQL functions, procedures and packages) of a particular type. Some system privileges examples:
-- ·CREATE SESSION (Enables a user to create a connection to the database. - bare minimum)
-- ·ADMIN (Enables a user to perform administrative tasks including checkpointing, backups, migration, and user creation and deletion.)
-- ·CACHE_MANAGER (Enables a user to perform operations related to cache groups.)
-- ·CREATE TABLE (Enables a user to create a table owned by that user.)
-- ·CREATE ANY TABLE ( To create a table in another user's schema, I must have the CREATE ANY TABLE privileges)
-- ·XLA (Enables a user to connect to a database as an XLA reader.)

-- 2.  What are object privileges concerned with?
-- .Object privilege target specifically object level security (data security). These are concerned with right to perform a particular action on an object or to access another user's object (table, view, materialized view, index, synonyms [converted to privileges on base table referenced by synonym], sequences, cache group, replication schemes, PL/SQL function, procedure, and package). Object's owner has all privileges for that object and can't be revoked. Owner can grant object privileges for that object to other DB users. Also a user with ADMIN privilege can grant and revoke object privileges from users who do not own the object under consideration. Examples:
-- ·ALTER, DELETE, INDEX, INSERT, REFRENCEs, SELECT, UPDATE table;
-- ·DELETE, INDEX, INSERT,  SELECT, UPDATE view;
-- ·ALTER (excluding START WITH), SELECT sequence;
-- ·EXECUTE procedure;
-- ·FLUSH,LOAD,REFRESH, UNLOAD ON Cache group

-- 3.  What is another name for object security?
-- Data Security

-- 4.  What commands are necessary to allow Scott access to the database with a password of tiger?
-- If I get:
-- ORA-01031: insufficient privileges
-- Means I don't have sufficient permissions for that action.


CREATE USER scott IDENTIFIED BY tiger;

-- If I wanted to give only create session privilege to scott ( he will also get privileges given as to public):
GRANT CREATE SESSION TO  scott;

-- If I wanted to give something more than create session, say create table, create sequence and so on:
GRANT CREATE SESSION, CREATE TABLE, CREATE sequence, CREATE VIEW TO scott;


-- Another way could be just giving a role: CONNECT which has privileges like CREATE SESSION and also other system privileges,
-- like CREATE TABLE.
GRANT CONNECT TO scott;

-- 5.  What are the commands to allow Scott to SELECT from and UPDATE the d_clients table?
GRANT SELECT, UPDATE ON hkumar.d_clients to scott;

-- Opposite:
REVOKE SELECT, UPDATE ON  d_clients FROM scott;

-- Verify:
SELECT * FROM user_tab_privs_made;

-- 6.  What is the command to allow everybody the ability to view the d_songs table?
GRANT SELECT ON hkumar.d_songs to PUBLIC;

-- Opposite:
REVOKE SELECT ON hkumar.d_songs FROM PUBLIC;

-- Verify:
SELECT * FROM user_tab_privs_made;

-- 7.  Query the data dictionary to view the object privileges granted to you the user.
SELECT * from user_tab_privs_recd;
DESC user_tab_privs_recd;


-- 8.  What privilege should a user be given to create tables?
-- CREATE TABLE -  Enables a user to create a table owned by that user.
-- CREATE ANY TABLE - Enables a user to create a table owned by any user in the database.

-- 9.  If you create a table, how can you pass along privileges to other users just to view your table?

GRANT SELECT ON hkumar.d_songs to   scott1, scott2, scott3;

-- Verify:
SELECT * FROM user_tab_privs_made;

-- 10. What syntax would you use to grant another user access to your copy_employees table?
-- I assume all type of permissions here now (if it were on read privilege I will use SELECT instead of ALL):
GRANT ALL ON hkumar.copy_employees to   scott1, scott2, scott3;

-- Verify:
SELECT * FROM user_tab_privs_made;

-- 11. How can you find out what privileges you have been granted for columns in the tables belonging to others?
SELECT * FROM user_col_privs_recd;


DESC user_col_privs_recd;