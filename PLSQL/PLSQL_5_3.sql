-- 1. Describe two benefits of using a cursor FOR loop.
-- It's easier to write a cursor FOR loop instead of open, fetch, notfound and close.
-- It's quicker and easier to read.

-- 2. Modify the following PL/SQL block so that it uses a cursor FOR loop. Keep the explicit cursor
-- declaration in the DECLARE section. Test your changes.
DECLARE
    CURSOR countries_cur IS
    SELECT country_name, national_holiday_name, national_holiday_date
    FROM countries
    WHERE region_id = 5;

    countries_rec countries_cur%ROWTYPE;

BEGIN
     OPEN countries_cur;
     LOOP
         FETCH countries_cur INTO countries_rec;
         EXIT WHEN countries_cur%NOTFOUND;
         DBMS_OUTPUT.PUT_LINE ('Country: ' || countries_rec.country_name
         || ' National holiday: '|| countries_rec.national_holiday_name
         || ', held on: '|| countries_rec.national_holiday_date);
     END LOOP;
     CLOSE countries_cur;
END;



DECLARE
     CURSOR countries_cur IS
     SELECT country_name, national_holiday_name, national_holiday_date
     FROM wf_countries
     WHERE region_id = 5;
     countries_rec countries_cur%ROWTYPE;
BEGIN
    FOR countries_rec IN countries_cur LOOP
        DBMS_OUTPUT.PUT_LINE ('Country: ' || countries_rec.country_name || ' National holiday: '|| countries_rec.national_holiday_name || ', held on: '|| countries_rec.national_holiday_date);
    END LOOP;
END;

-- 3. Modify your answer to question 2 to declare the cursor using a subquery in the FOR…LOOP
-- statement, rather than in the declaration section. Test your changes again.

BEGIN
    FOR countries_rec IN  (SELECT country_name, national_holiday_name, national_holiday_date FROM wf_countries WHERE region_id = 5) LOOP
        DBMS_OUTPUT.PUT_LINE ('Country: ' || countries_rec.country_name || ' National holiday: '|| countries_rec.national_holiday_name || ', held on: '|| countries_rec.national_holiday_date);
    END LOOP;
END;

-- 4. Using the COUNTRIES table, write a cursor that returns countries with a highest_elevation greater

cursor FOR loop, declaring the cursor using a subquery in the FOR…LOOP statement.
BEGIN
 FOR countries_rec IN  (SELECT country_name, highest_elevation, climate FROM wf_countries WHERE highest_elevation > 8000) LOOP
    DBMS_OUTPUT.PUT_LINE (countries_rec.country_name || ' '|| countries_rec.highest_elevation || ' '|| countries_rec.climate);
 END LOOP;
END;

-- 5. This question uses a join of the SPOKEN_LANGUAGES and COUNTRIES tables with a GROUP BY and HAVING clause.
-- Write a PL/SQL block to fetch and display all the countries that have more than six spoken
-- languages. For each such country, display country_name and the number of spoken languages.
-- Use a cursor FOR loop, but declare the cursor explicitly in the DECLARE section. After all the
-- rows have been fetched and displayed, display an extra row showing the total number of countries
-- having more than six languages. (Hint: Declare a variable to hold the value of %ROWCOUNT.)

DECLARE
 v_count NUMBER(4);
 CURSOR languages_cursor IS SELECT country_name, COUNT(*) AS number_countries
    FROM wf_countries c, wf_spoken_languages sl
    WHERE c.country_id = sl.country_id
    GROUP BY country_name HAVING COUNT(*) >6;
BEGIN
    FOR languages_rec IN languages_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(languages_rec.country_name || ' ' || languages_rec.number_countries);
        v_count := languages_cursor%ROWCOUNT;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_count);
END;