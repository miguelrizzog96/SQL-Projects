
--1.
CREATE OR REPLACE FUNCTION plch_start_date (
   frequency_in   IN VARCHAR2,
   date_in        IN DATE DEFAULT SYSDATE)
   RETURN VARCHAR2
IS
BEGIN
   IF frequency_in = 'Y'
   THEN
      RETURN TO_CHAR (ADD_MONTHS (date_in, -12), 'YYYY-MM-DD');
   ELSIF frequency_in = 'Q'
   THEN
      RETURN TO_CHAR (ADD_MONTHS (date_in, -3), 'YYYY-MM-DD');
   ELSIF frequency_in = 'M'
   THEN
      RETURN TO_CHAR (ADD_MONTHS (date_in, -1), 'YYYY-MM-DD');
   END IF;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      plch_start_date ('Y', DATE '2014-01-01'));
   DBMS_OUTPUT.put_line (
      plch_start_date ('Q', DATE '2014-01-01'));
   DBMS_OUTPUT.put_line (
      plch_start_date ('M', DATE '2013-11-01'));
END;
/

CREATE OR REPLACE FUNCTION plch_start_date (
   frequency_in   IN VARCHAR2,
   date_in        IN DATE DEFAULT SYSDATE)
   RETURN VARCHAR2
IS
BEGIN
   RETURN TO_CHAR (
             CASE frequency_in
                WHEN 'Y' THEN ADD_MONTHS (date_in, -12)
                WHEN 'Q' THEN ADD_MONTHS (date_in, -3)
                WHEN 'M' THEN ADD_MONTHS (date_in, -1)
             END,
             'YYYY-MM-DD');
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      plch_start_date ('Y', DATE '2014-01-01'));
   DBMS_OUTPUT.put_line (
      plch_start_date ('Q', DATE '2014-01-01'));
   DBMS_OUTPUT.put_line (
      plch_start_date ('M', DATE '2013-11-01'));
END;
/

CREATE OR REPLACE FUNCTION plch_start_date (
   frequency_in   IN VARCHAR2,
   date_in        IN DATE DEFAULT SYSDATE)
   RETURN VARCHAR2
IS
   TYPE shifts_t IS TABLE OF PLS_INTEGER
      INDEX BY VARCHAR2 (1);

   l_shifts   shifts_t;
BEGIN
   l_shifts ('M') := 1;
   l_shifts ('Q') := 3;
   l_shifts ('Y') := 12;

   RETURN TO_CHAR (
             ADD_MONTHS (date_in, -1 * l_shifts (frequency_in)),
             'YYYY-MM-DD');
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      plch_start_date ('Y', DATE '2014-01-01'));
   DBMS_OUTPUT.put_line (
      plch_start_date ('Q', DATE '2014-01-01'));
   DBMS_OUTPUT.put_line (
      plch_start_date ('M', DATE '2013-11-01'));
END;
/

CREATE OR REPLACE FUNCTION plch_start_date (
   frequency_in   IN VARCHAR2,
   date_in        IN DATE DEFAULT SYSDATE)
   RETURN VARCHAR2
IS
BEGIN
   RETURN TO_CHAR (
             ADD_MONTHS (
                date_in,
                CASE frequency_in
                   WHEN 'Y' THEN -12
                   WHEN 'Q' THEN -3
                   WHEN 'M' THEN -1
                END),
             'YYYY-MM-DD');
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      plch_start_date ('Y', DATE '2014-01-01'));
   DBMS_OUTPUT.put_line (
      plch_start_date ('Q', DATE '2014-01-01'));
   DBMS_OUTPUT.put_line (
      plch_start_date ('M', DATE '2013-11-01'));
END;
/

/* And no conditional logic at all! */

CREATE OR REPLACE FUNCTION plch_start_date (
   frequency_in   IN VARCHAR2,
   date_in        IN DATE DEFAULT SYSDATE)
   RETURN VARCHAR2
IS
BEGIN
   RETURN TO_CHAR ( TRUNC (date_in - 1, 
      REPLACE (frequency_in, 'M', 'MM')), 'YYYY-MM-DD');
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      plch_start_date ('Y', DATE '2014-01-01'));
   DBMS_OUTPUT.put_line (
      plch_start_date ('Q', DATE '2014-01-01'));
   DBMS_OUTPUT.put_line (
      plch_start_date ('M', DATE '2013-11-01'));
END;
/

/* Clean up */

DROP FUNCTION plch_start_date
/


--2.
/* Wrong - "null <= 8" is boolean NULL causing while loop to exit */
declare
   type numbers_t is table of number;
   numbers  numbers_t := numbers_t( 2, 4, null, 8, 10 );
   idx      number;
begin
   idx := 1;
   while numbers(idx) <= 8 loop
      if numbers(idx) is null then
         dbms_output.put_line('null');
      else
         dbms_output.put_line(numbers(idx));
      end if;
      idx := idx + 1;
   end loop;
end;
/

/* Wrong - "not (null <= 8)" is also boolean NULL */

declare
   type numbers_t is table of number;
   numbers  numbers_t := numbers_t( 2, 4, null, 8, 10 );
   idx      number;
begin
   idx := 1;
   while not numbers(idx) > 8 loop
      if numbers(idx) is null then
         dbms_output.put_line('null');
      else
         dbms_output.put_line(numbers(idx));
      end if;
      idx := idx + 1;
   end loop;
end;
/

/* Correct - using nvl we never get a boolean NULL condition */

declare
   type numbers_t is table of number;
   numbers  numbers_t := numbers_t( 2, 4, null, 8, 10 );
   idx      number;
begin
   idx := 1;
   while nvl(numbers(idx),0) <= 8 loop
      if numbers(idx) is null then
         dbms_output.put_line('null');
      else
         dbms_output.put_line(numbers(idx));
      end if;
      idx := idx + 1;
   end loop;
end;
/

/* Correct - "not null <= 8" is boolean null so we DO NOT exit loop */
 
declare
   type numbers_t is table of number;
   numbers  numbers_t := numbers_t( 2, 4, null, 8, 10 );
   idx      number;
begin
   idx := 1;
   loop
      exit when not numbers(idx) <= 8;
      if numbers(idx) is null then
         dbms_output.put_line('null');
      else
         dbms_output.put_line(numbers(idx));
      end if;
      idx := idx + 1;
   end loop;
end;
/

/* Correct - "null > 8" is boolean null so we DO NOT exit loop */

declare
   type numbers_t is table of number;
   numbers  numbers_t := numbers_t( 2, 4, null, 8, 10 );
   idx      number;
begin
   idx := 1;
   loop
      exit when numbers(idx) > 8;
      if numbers(idx) is null then
         dbms_output.put_line('null');
      else
         dbms_output.put_line(numbers(idx));
      end if;
      idx := idx + 1;
   end loop;
end;
/

CREATE TABLE plch_parts
(
   partnum    INTEGER
 , partname   VARCHAR2 (100)
)
/
--3
BEGIN
   INSERT INTO plch_parts VALUES (1, 'Mouse');
   INSERT INTO plch_parts VALUES (100, 'Keyboard');
   INSERT INTO plch_parts VALUES (500, 'Monitor');
   COMMIT;
END;
/

DECLARE
   CURSOR plch_parts_cur
   IS
      SELECT * FROM plch_parts;

   rec   plch_parts_cur%ROWTYPE;
BEGIN
   OPEN plch_parts_cur;

   LOOP
      FETCH plch_parts_cur INTO rec;
      EXIT WHEN plch_parts_cur%NOTFOUND;
      DBMS_OUTPUT.put_line (rec.partname);
   END LOOP;
END;
/

DECLARE
   CURSOR plch_parts_cur
   IS
      SELECT * FROM plch_parts;
BEGIN
   FOR rec IN plch_parts_cur
   LOOP
      DBMS_OUTPUT.put_line (rec.partname);
   END LOOP;
END;
/

DECLARE
   CURSOR plch_parts_cur
   IS
      SELECT * FROM plch_parts;

   TYPE plch_parts_t IS TABLE OF plch_parts_cur%ROWTYPE;

   l_parts   plch_parts_t;
BEGIN
   SELECT *
     BULK COLLECT INTO l_parts
     FROM plch_parts;

   FOR indx IN 1 .. l_parts.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_parts (indx).partname);
   END LOOP;
END;
/

BEGIN
   FOR rec IN (SELECT * FROM plch_parts)
   LOOP
      DBMS_OUTPUT.put_line (rec.partname);
   END LOOP;
END;
/

/* Clean up */

DROP TABLE plch_parts
/
--4.
CREATE TABLE plch_parts
(
   partnum    INTEGER PRIMARY KEY,
   partname   VARCHAR2 (100) NOT NULL
)
/

BEGIN
   INSERT INTO plch_parts
        VALUES (1, 'Webcam');

   INSERT INTO plch_parts
        VALUES (100, 'Keyboard');

   INSERT INTO plch_parts
        VALUES (500, 'Monitor');

   COMMIT;
END;
/

CREATE OR REPLACE PACKAGE plch_pkg
IS
   TYPE parts_t IS TABLE OF plch_parts%ROWTYPE
      INDEX BY PLS_INTEGER;

   PROCEDURE process_parts (parts_in IN parts_t);
END plch_pkg;
/

/* FOR loop with EXIT */

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   PROCEDURE process_parts (parts_in IN parts_t)
   IS
   BEGIN
      FOR indx IN 1 .. parts_in.COUNT
      LOOP
         IF parts_in (indx) = 'Monitor'
         THEN
            EXIT;
         ELSE
            DBMS_OUTPUT.put_line (parts_in (indx));
         END IF;
      END LOOP;
   END;
END plch_pkg;
/

DECLARE
   l_parts   plch_pkg.parts_t;
BEGIN
     SELECT *
       BULK COLLECT INTO l_parts
       FROM plch_parts
   ORDER BY partname;

   plch_pkg.process_parts (l_parts);
END;
/

/* WHILE loop - good! */

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   PROCEDURE process_parts (parts_in IN parts_t)
   IS
      idx   PLS_INTEGER := parts_in.FIRST;
   BEGIN
      WHILE (idx IS NOT NULL AND parts_in (idx) <> 'Monitor')
      LOOP
         DBMS_OUTPUT.put_line (parts_in (idx));
         idx := parts_in.NEXT (idx);
      END LOOP;
   END;
END plch_pkg;
/

DECLARE
   l_parts   plch_pkg.parts_t;
BEGIN
     SELECT *
       BULK COLLECT INTO l_parts
       FROM plch_parts
   ORDER BY partname;

   plch_pkg.process_parts (l_parts);
END;
/

/* WHILE with EXIT - no! */

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   PROCEDURE process_parts (parts_in IN parts_t)
   IS
      idx   PLS_INTEGER := parts_in.FIRST;
   BEGIN
      WHILE (idx IS NOT NULL)
      LOOP
         EXIT WHEN parts_in (idx) = 'Monitor';
         DBMS_OUTPUT.put_line (parts_in (idx));
         idx := parts_in.NEXT (idx);
      END LOOP;
   END;
END plch_pkg;
/


DECLARE
   l_parts   plch_pkg.parts_t;
BEGIN
     SELECT *
       BULK COLLECT INTO l_parts
       FROM plch_parts
   ORDER BY partname;

   plch_pkg.process_parts (l_parts);
END;
/

/* Simple loop with two EXITs - no! */

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   PROCEDURE process_parts (parts_in IN parts_t)
   IS
      idx   PLS_INTEGER := parts_in.LAST;
   BEGIN
      LOOP
         EXIT WHEN idx IS NULL OR parts_in (idx) = 'Monitor';
         DBMS_OUTPUT.put_line (parts_in (idx));
         idx := parts_in.PRIOR (idx);
      END LOOP;
   END;
END plch_pkg;
/

DECLARE
   l_parts   plch_pkg.parts_t;
BEGIN
     SELECT *
       BULK COLLECT INTO l_parts
       FROM plch_parts
   ORDER BY partname;

   plch_pkg.process_parts (l_parts);
END;
/

/* Clean up */

DROP TABLE plch_parts
/

DROP PACKAGE plch_pkg
/

CREATE TABLE plch_employees
(
   employee_id   INTEGER
 ,  last_name     VARCHAR2 (100)
 ,  salary        NUMBER
)
/

BEGIN
   INSERT INTO plch_employees
        VALUES (100, 'Feuerstein', 10000);

   INSERT INTO plch_employees
        VALUES (200, 'Ellison', 1000000);

   COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE plch_tester (
   title_in IN VARCHAR2)
IS
   l_row   plch_employees%ROWTYPE;
BEGIN
   DBMS_OUTPUT.put_line (title_in);

   BEGIN
      l_row := plch_one_employee (NULL);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('NULL -> ' || SQLCODE);
   END;

   BEGIN
      l_row := plch_one_employee (-1);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('-1 -> ' || SQLCODE);
   END;
END;
/

/* Plain vanilla implicit cursor */

CREATE OR REPLACE FUNCTION plch_one_employee (
   employee_id_in IN PLS_INTEGER)
   RETURN plch_employees%ROWTYPE
IS
   l_return   plch_employees%ROWTYPE;
BEGIN
   SELECT *
     INTO l_return
     FROM plch_employees
    WHERE employee_id = employee_id_in;

   RETURN l_return;
END plch_one_employee;
/

BEGIN
   plch_tester ('Default implicit cursor behavior');
END;
/

/* Plain vanilla explicit cursor */

CREATE OR REPLACE FUNCTION plch_one_employee (
   employee_id_in IN PLS_INTEGER)
   RETURN plch_employees%ROWTYPE
IS
   CURSOR one_emp_cur
   IS
      SELECT *
        FROM plch_employees
       WHERE employee_id = employee_id_in;

   l_return   one_emp_cur%ROWTYPE;
BEGIN
   OPEN one_emp_cur;
   FETCH one_emp_cur INTO l_return;
   CLOSE one_emp_cur;

   RETURN l_return;
END plch_one_employee;
/

BEGIN
   plch_tester ('Default explicit cursor behavior');
END;
/

/* Add assertion for null to implicit */

CREATE OR REPLACE FUNCTION plch_one_employee (
   employee_id_in IN PLS_INTEGER)
   RETURN plch_employees%ROWTYPE
IS
   l_return   plch_employees%ROWTYPE;
BEGIN
   IF employee_id_in IS NULL
   THEN
      RAISE VALUE_ERROR;
   END IF;

   SELECT *
     INTO l_return
     FROM plch_employees
    WHERE employee_id = employee_id_in;

   RETURN l_return;
END plch_one_employee;
/

BEGIN
   plch_tester ('Implicit cursor with check for NULL');
END;
/

/* Add all necessary code to explicit cursor */

CREATE OR REPLACE FUNCTION plch_one_employee (
   employee_id_in IN PLS_INTEGER)
   RETURN plch_employees%ROWTYPE
IS
   CURSOR one_emp_cur
   IS
      SELECT *
        FROM plch_employees
       WHERE employee_id = employee_id_in;

   l_return   one_emp_cur%ROWTYPE;
BEGIN
   IF employee_id_in IS NULL
   THEN
      RAISE VALUE_ERROR;
   END IF;

   OPEN one_emp_cur;
   FETCH one_emp_cur INTO l_return;

   IF one_emp_cur%NOTFOUND
   THEN
      CLOSE one_emp_cur;
      RAISE NO_DATA_FOUND;
   ELSE
      CLOSE one_emp_cur;
      RETURN l_return;
   END IF;
END plch_one_employee;
/

BEGIN
   plch_tester (
      'Explicit cursor with check for NULL and row found');
END;
/

/* Clean up */

DROP TABLE plch_employees
/

DROP PROCEDURE plch_tester
/

DROP FUNCTION plch_one_employee
/

CREATE OR REPLACE FUNCTION plch_right (string_in   IN VARCHAR2,
                                       length_in   IN INTEGER)
   RETURN VARCHAR2
IS
BEGIN
   RETURN right (string_in, length_in);
END plch_right;
/

SHOW ERRORS FUNCTION plch_right

CREATE OR REPLACE PROCEDURE plch_tester
IS
BEGIN
   DBMS_OUTPUT.put_line ('Right?');
   DBMS_OUTPUT.put_line ('0 => ' || plch_right ('abcdefg', 0));
   DBMS_OUTPUT.put_line ('5 => ' || plch_right ('abcdefg', 5));
   DBMS_OUTPUT.put_line ('15=> ' || plch_right ('abcdefg', 15));
END plch_tester;
/

BEGIN
   plch_tester;
END;
/

/* Unnecessarily complex */

CREATE OR REPLACE FUNCTION plch_right (string_in   IN VARCHAR2,
                                       length_in   IN INTEGER)
   RETURN VARCHAR2
IS
BEGIN
   RETURN CASE length_in
             WHEN 0
             THEN
                NULL
             ELSE
                SUBSTR (
                   string_in,
                   CASE
                      WHEN (LENGTH (string_in) < length_in)
                      THEN
                         (0 - LENGTH (string_in))
                      ELSE
                         (0 - length_in)
                   END)
          END;
END plch_right;
/

BEGIN
   plch_tester;
END;
/

/* Positive number does not work here */

CREATE OR REPLACE FUNCTION plch_right (string_in   IN VARCHAR2,
                                       length_in   IN INTEGER)
   RETURN VARCHAR2
IS
BEGIN
   RETURN CASE length_in
             WHEN 0
             THEN
                NULL
             ELSE
                SUBSTR (string_in,
                        LEAST (length_in, LENGTH (string_in)))
          END;
END plch_right;
/

BEGIN
   plch_tester;
END;
/

/* Incorrect use of LEAST, after application of minus */

CREATE OR REPLACE FUNCTION plch_right (string_in   IN VARCHAR2,
                                       length_in   IN INTEGER)
   RETURN VARCHAR2
IS
BEGIN
   RETURN CASE length_in
             WHEN 0
             THEN
                NULL
             ELSE
                SUBSTR (string_in,
                        LEAST (-length_in, -LENGTH (string_in)))
          END;
END plch_right;
/

BEGIN
   plch_tester;
END;
/

/* Much better - just use a negative start location, but with
   special logic for a length > LENGTH (string_in) */

CREATE OR REPLACE FUNCTION plch_right (string_in   IN VARCHAR2,
                                       length_in   IN INTEGER)
   RETURN VARCHAR2
IS
BEGIN
   RETURN CASE length_in
             WHEN 0
             THEN
                NULL
             ELSE
                SUBSTR (string_in,
                        -LEAST (length_in, LENGTH (string_in)))
          END;
END plch_right;
/

BEGIN
   plch_tester;
END;
/

/* Forget about least. Just go with - */

CREATE OR REPLACE FUNCTION plch_right (string_in   IN VARCHAR2,
                                       length_in   IN INTEGER)
   RETURN VARCHAR2
IS
BEGIN
   RETURN CASE length_in
             WHEN 0 THEN NULL
             ELSE SUBSTR (string_in, -length_in)
          END;
END plch_right;
/

BEGIN
   plch_tester;
END;
/

/* Use NULL IF to handle special logic for 0 length. */

CREATE OR REPLACE FUNCTION plch_right (string_in   IN VARCHAR2,
                                       length_in   IN INTEGER)
   RETURN VARCHAR2
IS
BEGIN
   RETURN SUBSTR (string_in,
               -LEAST (NULLIF (length_in, 0), LENGTH (string_in)));
END plch_right;
/

BEGIN
   plch_tester;
END;
/

/* Clean up */

DROP PROCEDURE plch_tester
/

DROP FUNCTION plch_right
/

--Exercise 1: Simple PL/SQL Block
--Write a PL/SQL block that declares a variable for an employee's last name, 
--retrieves it from the database, and prints it using DBMS_OUTPUT.PUT_LINE.
DECLARE
    -- Declaration section: variables, constants, cursors, etc.
    v_last_name VARCHAR2(256);
    c_EMP_NO NUMBER :=10003;

BEGIN
    SELECT LAST_NAME INTO v_last_name
    FROM employees
    WHERE EMP_NO= c_EMP_NO;
DBMS_OUTPUT.PUT_LINE('The employees Last Name is '  || v_LAST_NAME);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee not found');

END;

--Exercise 2: Conditional Logic
--Create a PL/SQL block that checks an employee's department. 
--If the department is 'Sales', give the employee a bonus of 10% of their salary. 
--If not, print a message saying no bonus.


DECLARE
    v_dept_name DEPARTMENTS.DEPT_NAME%TYPE;
    v_emp_no EMPLOYEES.EMP_NO%TYPE := 10002;
    v_dept DEPARTMENTS.DEPT_NAME%TYPE := 'Sales';
    v_date SALARIES.FROM_DATE%TYPE;
    -- Use SELECT INTO to fetch the department name
BEGIN
    -- Fetch the department name for the given employee
    SELECT d.DEPT_NAME 
    INTO v_dept_name
    FROM dept_emp de 
    INNER JOIN DEPARTMENTS d ON de.DEPT_NO = d.DEPT_NO
    WHERE de.EMP_NO = v_emp_no;
    SELECT MAX(FROM_DATE) INTO v_date FROM salaries
    WHERE emp_no=v_emp_no;
    
    -- Compare the fetched department name with the given department name
    IF v_dept_name = v_dept THEN
        UPDATE salaries 
        SET salary = salary * 1.1  
        WHERE EMP_NO = v_emp_no AND v_date=FROM_DATE;
        DBMS_OUTPUT.PUT_LINE('THERE is bonus for this employee :)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No bonus for this employee :(');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee or Department not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;

ROLLBACK;
SELECT * FROM salaries WHERE EMP_NO=10002;
--Exercise 3: Looping
--Write a PL/SQL block that retrieves all employee IDs 
--from the employees table and prints each one using a loop.
BEGIN
    FOR i IN (SELECT EMP_NO FROM employees)
        LOOP
            DBMS_OUTPUT.PUT_LINE('EMPLOYEE_ID: ' || i.EMP_NO);
        END LOOP;
END;