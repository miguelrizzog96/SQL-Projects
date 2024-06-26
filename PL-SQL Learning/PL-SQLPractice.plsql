SET SERVEROUTPUT ON;
-- 1. Print as output the 10 circuits with the most altitude in F1
BEGIN 
    FOR I IN (
    SELECT NAME, LOCATION , alt
    FROM CIRCUITS
    ORDER BY ALT DESC
    FETCH FIRST 10 ROWS ONLY
    )
    LOOP
        DBMS_Output.Put_Line ('Circuit = ' || i.NAME  || ', ' ||
        'Location = ' || i.LOCATION);
    END LOOP;
END;

-- 1. STRUCTURE OF A PL/SQL BLOCK
DECLARE
    -- Declaration section: variables, constants, cursors, etc.
    variable_name datatype NOT NULL := value; --Variables: Declared with a name and data type. Can be initialized with a default value.
    constant_name CONSTANT datatype := value; --Constants: Declared with a name, data type, and must be initialized with a value.
    CURSOR cursor_name IS SELECT_statement; --Cursors: Declared to retrieve multiple rows from a query.

BEGIN
    -- Execution section: procedural code
    -- Statements to execute (SQL statements, control structures, etc.)
    NULL; -- Placeholder statement; does nothing

EXCEPTION
    -- Exception handling section: handles errors
    WHEN exception_name1 THEN
        -- Statements to handle the exception
        NULL;
    WHEN OTHERS THEN
        -- Statements to handle any exception not explicitly named
        NULL;

END;

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

--2. Variables
-- multiple blocks use "/"
DECLARE
    v_salary NUMBER(8);
BEGIN
    SELECT MAX(salary) into v_salary --3. select into
    FROM SALARIES
    WHERE emp_no=10001;
    DBMS_OUTPUT.PUT_LINE(v_salary);
END;
/
DECLARE
    v_salary NUMBER(8);
    v_name VARCHAR(100);
    v_date SALARIES.FROM_DATE%TYPE; 
    --Above is an anchored datatype meaning uses data type from underlying table (salaries.FROM_DATE)
BEGIN
    SELECT MAX(FROM_DATE) INTO v_date FROM salaries
    WHERE emp_no = 10001;

    SELECT salary, first_name || ' ' || last_name INTO v_salary, v_name
    FROM salaries
    INNER JOIN employees
    ON salaries.emp_no = employees.emp_no
    WHERE salaries.emp_no = 10001 AND salaries.FROM_DATE = v_date;

    DBMS_OUTPUT.PUT_LINE( v_name || ' Is clearing ' || v_salary  ||' a year, Nice!' );
END;


-- 5. Constants
DECLARE
    mi_nombre CONSTANT VARCHAR(256) := 'Miguel Angel Rizzo Gonzalez';
BEGIN
    DBMS_OUTPUT.PUT_LINE(mi_nombre);
END;
/
-- can also declare with default
DECLARE
    mi_nombre CONSTANT VARCHAR(256) NOT NULL DEFAULT 'Miguel Angel Rizzo Gonzalez';
BEGIN
    DBMS_OUTPUT.PUT_LINE(mi_nombre);
END;

-- 6. Bind variables, also called Host variables
VARIABLE v_bind1 VARCHAR2(10);
EXECUTE : v_bind1 := 'Voyager';
--2nd way of initializing
BEGIN
    :v_bind1 := 'bind_assigned_2nd_way';
    DBMS_OUTPUT.PUT_LINE(:v_bind1);
END;
PRINT :v_bind;
SET AUTOPRINT ON;
--7.  Control Statements
--8. IF- THEN
DECLARE
    v_num NUMBER :=9;
BEGIN
    IF v_num < 10 THEN
        DBMS_OUTPUT.PUT_LINE('Inside the IF');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Outside the IF');
END;

-- 9. IF ELSE
DECLARE
    v_num NUMBER := &enter_a_number; -- "&" Prompts the user for a value
BEGIN
    IF MOD (v_num,2)=0 THEN
        DBMS_OUTPUT.PUT_LINE( v_num || ' Is Even');
    ELSE
        DBMS_OUTPUT.PUT_LINE( v_num || ' Is Odd');
    END IF;
        DBMS_OUTPUT.PUT_LINE('Statement completed');
END;

--10. IF THEN ELSEIF
DECLARE
    sales number :=50000;
    bonus number ;
BEGIN
    IF sales > 50000 THEN
    bonus := 1500;
    ELSIF sales > 35000 THEN
    bonus := 500;
    ELSE
    bonus := 100;
    END IF;
END;

--11. LOOPS
-- FOR loop
DECLARE 
    stop Number :=10;
BEGIN
    FOR i IN REVERSE 0 .. stop -- reverse statement
        LOOP
            DBMS_OUTPUT.PUT_LINE(i);
         END LOOP;
END; 

-- 12. While loop 
DECLARE 
    i NUMBER :=0;
BEGIN
    WHILE i<9 LOOP
    i:= i+1;
    DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;

--14. triggers in PL/SQL
-- used to trigger Events , DML,DCL,DDL ,SYSTEM/DB triggers,Instead-of Triggers
--Compound triggers
--15 DML trigger 

SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER bi_employees -- before insert
BEFORE INSERT ON employees
FOR EACH ROW
ENABLE
DECLARE
    v_user VARCHAR2(20);
BEGIN
    SELECT user INTO v_user FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('New row added by ' || v_user);
END;
/
INSERT INTO employees  VALUES(50000,'31/10/96','Miguel','Rizzo','M','24/06/24');

CREATE OR REPLACE TRIGGER bu_employees -- before update
BEFORE UPDATE ON employees
FOR EACH ROW
ENABLE
DECLARE
    v_user VARCHAR2(20);
BEGIN
    SELECT user INTO v_user FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('Row Updated by ' || v_user);
END;
/
UPDATE employees SET gender='M' WHERE LAST_NAME='Rizzo';
COMMIT;

CREATE OR REPLACE TRIGGER bu_employees -- for all
BEFORE UPDATE OR DELETE OR INSERT ON employees
FOR EACH ROW
ENABLE
DECLARE
    v_user VARCHAR2(20);
BEGIN
    SELECT user INTO v_user FROM DUAL;
    IF INSERTING THEN
        DBMS_OUTPUT.PUT_LINE('Row Inserted by ' || v_user);
    ELSIF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('Row Deleted by ' || v_user);
    ELSIF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('Row Updated by ' || v_user);
    END IF;
END;
/
DELETE FROM employees  WHERE LAST_NAME='Rizzo';

-- 16. Table auditing using Triggers
CREATE TABLE emp_audit(
    new_name VARCHAR2(20),
    old_name VARCHAR2(20),
    user_name VARCHAR2(20),
    entry_date TIMESTAMP,
    operation VARCHAR (20));

CREATE OR REPLACE TRIGGER employees_audit
BEFORE INSERT OR DELETE OR UPDATE ON employees
FOR EACH ROW
ENABLE
DECLARE
    v_user emp_audit.user_name%TYPE;
    v_entry_date emp_audit.entry_date%TYPE; -- Assuming entry_date is a column in emp_audit table
BEGIN
    SELECT USER, SYSDATE INTO v_user, v_entry_date FROM DUAL;
    
    IF INSERTING THEN
        INSERT INTO emp_audit VALUES(
            :NEW.EMP_NO , NULL, v_user, v_entry_date, 'INSERT');
    ELSIF DELETING THEN
        INSERT INTO emp_audit VALUES(
            NULL, :OLD.EMP_NO , v_user, v_entry_date, 'DELETE');
    ELSIF UPDATING THEN
        INSERT INTO emp_audit VALUES(
            :NEW.EMP_NO , :OLD.EMP_NO , v_user, v_entry_date, 'UPDATE');
    END IF;
END;

UPDATE employees SET FIRST_NAME='Miguel Angel' WHERE FIRST_NAME='Miguel';
DELETE  FROM emp_audit WHERE USER_NAME IS NOT NULL;
COMMIT;
ROLLBACK;

-- Table synchronized backup oof a table using DML triggers

CREATE TABLE employees_backup AS SELECT * FROM employees WHERE 1=2;

CREATE OR REPLACE TRIGGER backup_emp
BEFORE INSERT OR DELETE OR UPDATE ON employees
FOR EACH ROW
ENABLE
BEGIN
    IF INSERTING THEN
        INSERT INTO employees_backup (EMP_NO,BIRTH_DATE,FIRST_NAME,LAST_NAME,GENDER,HIRE_DATE)
        VALUES(:NEW.EMP_NO,:NEW.BIRTH_DATE,:NEW.FIRST_NAME,:NEW.LAST_NAME,:NEW.GENDER,:NEW.HIRE_DATE);
    ELSIF DELETING THEN
        DELETE FROM employees_backup WHERE EMP_NO=:OLD.EMP_NO;
    ELSIF UPDATING THEN
        UPDATE employees_backup SET EMP_NO=:NEW.EMP_NO,
                            BIRTH_DATE=:NEW.BIRTH_DATE,
                            FIRST_NAME=:NEW.FIRST_NAME,
                            LAST_NAME=:NEW.LAST_NAME,
                            GENDER=:NEW.GENDER,
                            HIRE_DATE=:NEW.HIRE_DATE
        WHERE EMP_NO=:OLD.EMP_NO;
    END IF;
END;


COMMIT;
INSERT INTO EMPLOYEES VALUES (10001,'31/10/96','Miguel','Rizzo','M','09/07/24');
DELETE FROM employees;
ROLLBACK;
SELECT * FROM EMPLOYEES;
SELECT * FROM emp_audit;
SELECT * FROM employees_backup;

ALTER TABLE emp_audit RENAME COLUMN  OLD_NAME to OLD_ID;
COMMIT;