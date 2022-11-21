-- 1. In your own words, explain the difference between implicit and explicit cursors.

-- The implicit cursor is automatically created by the database in some situations (Ex. Insert, Update, Delete, Merge or Select with a single row)

-- The exmplicit cursor is created by the user and can have more rows.

-- 2. Which SQL statement can use either an explicit or an implicit cursor, as needed?
SELECT clause that return a single row

UPDATE a single row

-- 3. List two circumstances in which you would use an explicit cursor.
-- Statements that return more than one row
-- Updates on more than one row

-- 4. Exercise using CURRENCIES tables:

-- A. Write a PL/SQL block to declare a cursor called currencies_cur. The cursor will be used to
-- read and display all rows from the CURRENCIES table. You will need to retrieve currency_code and currency_name, ordered by ascending currency_name.

DECLARE
    CURSOR currencies_cur IS
    SELECT currency_code, currency_name
    FROM wf_currencies
    ORDER BY currency_name;

-- B. Add a statement to open the currencies_cur cursor.

DECLARE
    CURSOR currencies_cur IS
    SELECT currency_code, currency_name
    FROM wf_currencies
    ORDER BY currency_name;
BEGIN
    OPEN currencies_cur;
END;

-- C. Add variable declarations and an executable statement to read ONE row through the currencies_cur cursor into local variables.

DECLARE
    CURSOR currencies_cur IS
    SELECT currency_code, currency_name
    FROM wf_currencies
    ORDER BY currency_name;

    v_currency_code wf_currencies.currency_code%TYPE;
    v_currency_name wf_currencies.currency_name%TYPE;
BEGIN
    OPEN currencies_cur;
    FETCH currencies_cur INTO v_currency_code, v_currency_name;
    CLOSE currencies_cur;
END;

-- D. Add a statement to display the fetched row, and a statement to close the currencies_cur cursor.

DECLARE
    CURSOR currencies_cur IS
    SELECT currency_code, currency_name
    FROM wf_currencies
    ORDER BY currency_name;

    v_currency_code wf_currencies.currency_code%TYPE;
    v_currency_name wf_currencies.currency_name%TYPE;
BEGIN
    OPEN currencies_cur;
    FETCH currencies_cur INTO v_currency_code, v_currency_name;
    DBMS_OUTPUT.PUT_LINE(v_currency_code || ' ' || v_currency_name);

    CLOSE currencies_cur;
END;

-- F. Your code so far displays only one row. Modify your code so that it fetches and displays all the
-- rows, using a LOOP and EXIT statement. Test your modified block. It should fetch and display
-- each row in the CURRENCIES table. If it doesn't, check that your EXIT statement is in the
-- correct place in the code.

DECLARE
    CURSOR currencies_cur IS
    SELECT currency_code, currency_name
    FROM wf_currencies
    ORDER BY currency_name;
    v_currency_code wf_currencies.currency_code%TYPE;
    v_currency_name wf_currencies.currency_name%TYPE;

BEGIN
    OPEN currencies_cur;
    LOOP
        FETCH currencies_cur INTO v_currency_code, v_currency_name;
        EXIT WHEN currencies_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_currency_code || ' ' || v_currency_name);
    END LOOP;
CLOSE currencies_cur;
END;

-- G. Write and test a PL/SQL block to read and display all the rows in the COUNTRIES table for all
-- countries in region 5 (South America region). For each selected country, display the
-- country_name, national_holiday_date, and national_holiday_name. Display only those
-- countries having a national holiday date that is not null. Save your code (you will need it in the
-- next practice).

DECLARE
    CURSOR countries_cur IS
    SELECT country_name, national_holiday_date, national_holiday_name
    FROM wf_countries
    WHERE region_id = 5 AND national_holiday_date IS NOT NULL;

    v_country_name wf_countries.country_name%TYPE;
    v_national_holiday_date wf_countries.national_holiday_date%TYPE;
    v_national_holiday_name wf_countries.national_holiday_name%TYPE;
BEGIN
    OPEN countries_cur;
    LOOP
        FETCH countries_cur INTO v_country_name, v_national_holiday_date, v_national_holiday_name;
        EXIT WHEN countries_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_country_name || ' ' || v_national_holiday_date || ' ' || v_national_holiday_name);
    END LOOP;
CLOSE countries_cur;
END;

-- 5. Identify three guidelines for declaring and using explicit cursors.
-- Always open the cursor before using it
-- Fetch each row, one at a time
-- Always close the cursor after using it

-- 6. Write a PL/SQL block to read and display the names of world regions, with a count of the number
-- of countries in each region. Include only those regions having at least 10 countries. Order your
-- output by ascending region name.

DECLARE
    v_region_id wf_world_regions.region_id%TYPE;
    v_count NUMBER(2);
    v_region_name wf_world_regions.region_name%TYPE;
    CURSOR regions_cur IS
    SELECT region_id
    FROM wf_world_regions;
BEGIN
    OPEN regions_cur;
    LOOP
        FETCH regions_cur INTO v_region_id;
        EXIT WHEN regions_cur%NOTFOUND;
        SELECT count(country_id) INTO v_count FROM wf_countries WHERE region_id = v_region_id;
        IF v_count >= 10 THEN
            SELECT region_name INTO v_region_name
            FROM wf_world_regions
            WHERE region_id = v_region_id;
            DBMS_OUTPUT.PUT_LINE(v_region_name || ' ' || v_count);
        END IF;
    END LOOP;
CLOSE regions_cur;
END;