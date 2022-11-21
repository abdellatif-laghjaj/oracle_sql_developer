-- 1. What is a role?
-- A role is named group of related privileges that can be granted to users.

-- 2.  What are the advantages of a role to a DBA?
-- It makes easier to grant/revoke/maintain privileges. A user can be given multiple roles and a role could be assigned to multiple users. So, rather than assigning multiple privileges to a user, I may prefer to assign/revoke a role and I am good to go.
-- It also means, a user having multiple roles get all the privileges in all assigned roles.

-- 3.  Give the ability to another user in your class to look at one of your tables. Give him the right to let other students have that ability.
GRANT SELECT ON hkumar.d_clients to strange_uname
WITH GRANT OPTION;

-- Verify:
SELECT * FROM user_tab_privs_made;

REVOKE  SELECT ON  hkumar.d_clients  FROM strange_uname;

SELECT * FROM user_tab_privs_made;


-- 4.  You are the DBA. You are creating many users who require the same system privileges. What should you use to make your job easier?
-- I will group together the privileges in role. And grant this role to the user.
-- If there are multiple set of privileges given based on what kind of job user does

-- 5.  What is the syntax to accomplish the following?
-- a.  Create a role of manager that has the privileges to select, insert, and update and delete from the employees table
CREATE ROLE manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON employees TO manager;

-- b.  Create a role of clerk that just has the privileges of select and insert on the employees table
CREATE ROLE clerk;
GRANT SELECT, INSERT ON employees TO clerk;

-- c.  Grant the manager role to user scott
GRANT manager TO scott;

-- d.  Revoke the ability to delete from the employees table from the manager role
REVOKE DELETE ON employees FROM manager;

-- 6.  What is the purpose of a database link?
-- DB link is a pointer that defines a one-way communication path from one oracle DB to another oracle db.
-- They allow users to access another user's objects in a remote DB, so that they are bounded by the privilege set of the object's owner. A local user gets access to remote database via DB link.  Database Links allow users to work on remote database objects without having to log into the other database.
