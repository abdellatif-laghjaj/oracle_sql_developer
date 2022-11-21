-- 1. Complete the following chart defining the syntactical requirements for a PL/SQL block:

-- Optional or Mandatory? Describe what is included in this section
-- DECLARE      optional................declaration of the variables
-- BEGIN        mandatory................the executable part
-- EXCEPTION    optional................an error returned
-- END;         mandatory................the end of the executable part

-- 2. Which of the following PL/SQL blocks executes successfully? For the blocks that fail, explain why they fail



-- A.
BEGIN
END;
-- Fails because the executable section must contain at least one statement.

-- B.
DECLARE
    amount INTEGER(10);
END;
-- Fails because there is no executable section (BEGIN is missing).

-- C.
DECLARE
BEGIN
END;
-- Fails because the executable section must contain at least one statement.

-- D.
DECLARE
    amount NUMBER(10);
BEGIN
    DBMS_OUTPUT.PUT_LINE(amount);
END;
-- Succeeds

-- 3. Fill in the blanks:

-- A. PL/SQL blocks that have no names are called anonymous blocks

-- B. Procedures and Functions are named blocks and are stored in thedatabase.

-- 4. In Application Express, create and execute a simple anonymous block that outputs “Hello World.”

BEGIN
    DBMS_OUTPUT.PUT_LINE ('Hello World');
END;

-- 5. Create and execute a simple anonymous block that does the following:
-- • Declares a variable of datatype DATE and populates it with the date that is six months from today
-- • Outputs “In six months, the date will be: <insert date>.”

declare
    var DATE:= ADD_Months(SYSDATE,6);
begin
    DBMS_output.put_line('In six months, the date will be: '|| var||'.');
end;