
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

-- * 1. STRUCTURE OF A PL/SQL BLOCK
-- !DECLARE
--     -- Declaration section: variables, constants, cursors, etc.
--?   variable_name datatype NOT NULL := value; --Variables: Declared with a name and data type. Can be initialized with a default value.
--?  constant_name CONSTANT datatype := value; --Constants: Declared with a name, data type, and must be initialized with a value.
--?   CURSOR cursor_name IS SELECT_statement; --Cursors: Declared to retrieve multiple rows from a query.
-- !BEGIN
--     -- Execution section: procedural code
--     -- Statements to execute (SQL statements, control structures, etc.)
--?  NULL; -- Placeholder statement; does nothing

-- !EXCEPTION (Optional)
--     -- Exception handling section
--?  WHEN exception_name1 THEN
--    -- Statements to handle the exception
--?    NULL;
--?  WHEN OTHERS THEN
   -- Statements to handle any exception not explicitly named
--?      NULL;
--! END;

--*2., 3.  Variables, SELECT INTO
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
    -- * 4. Above is an anchored datatype meaning uses data type from underlying table (salaries.FROM_DATE)
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


--* 5. Constants
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
PRINT : v_bind1;
SET AUTOPRINT ON;
--*7.  Control Statements
--*8. IF- THEN
DECLARE
    v_num NUMBER :=9;
BEGIN
    IF v_num < 10 THEN
        DBMS_OUTPUT.PUT_LINE('Inside the IF');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Outside the IF');
END;

--* 9. IF ELSE
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

--* 10. IF THEN ELSEIF
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

--* 11. LOOPS
--* 13. FOR loop
DECLARE 
    stop Number :=10;
BEGIN
    FOR i IN REVERSE 0 .. stop -- REVERSE statement to count from end to start
        LOOP
            DBMS_OUTPUT.PUT_LINE(i);
         END LOOP;
END; 

--* 12. While loop 
DECLARE 
    i NUMBER :=0;
BEGIN
    WHILE i<9 LOOP
    i:= i+1;
    DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;

--*14. triggers in PL/SQL
-- used to trigger Events , DML,DCL,DDL ,SYSTEM/DB triggers,Instead-of Triggers
--Compound triggers
--*15 DML trigger 

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

-- *16. Table auditing using Triggers
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

--* 17 Table synchronized backup oof a table using DML triggers

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


INSERT INTO EMPLOYEES VALUES (10001,'31/10/96','Miguel','Rizzo','M','09/07/24');
SELECT * FROM EMPLOYEES;
SELECT * FROM emp_audit;
SELECT * FROM employees_backup;

ALTER TABLE emp_audit RENAME COLUMN  OLD_NAME to OLD_ID;
SELECT EMP_no, OLD_ID FROM EMPLOYEES_BACKUP, emp_audit; -- two table at the same time
-- * 18. DDL trigger with schema auditing example
 SHOW user;
 CREATE TABLE schema_audit(
    ddl_date DATE,
    ddl_uer VARCHAR(15),
    object_created VARCHAR2(15),
    object_name VARCHAR(15),
    ddl_operation varchar2(15)
 );
ALTER TABLE schema_audit
MODIFY (
  ddl_uer VARCHAR(200),
  object_created VARCHAR2(200),
  object_name VARCHAR(200),
  ddl_operation VARCHAR2(200)
);
 COMMIT;
 ALTER TRIGGER ddl_chg_tracker ENABLE;
 CREATE OR REPLACE TRIGGER ddl_chg_tracker
 AFTER DDL ON SCHEMA -- also works for AFTER OR DROP etc.
 BEGIN
    INSERT INTO schema_audit VALUES(
        SYSDATE,
        sys_context('USERENV','CURRENT_USER'),
        ora_dict_obj_type,
        ora_dict_obj_name,
        ora_sysevent
    );
END;
/
DROP TABLE CIRCUITS;
SELECT * FROM schema_audit;
ROLLBACK;
-- * 19 LOG ON TRIGGERS
CREATE TABLE CONNECTIONS_LOG (
 LOG_ID NUMBER, 
 USER_NAME VARCHAR2 (20),
 EVENT_TYPE VARCHAR2(20),
 LOGON_DATE DATE,
 LOGON_TIME VARCHAR2(20),
 LOGOFF_DATE DATE,
 LOGOFF_TIME VARCHAR2(20)
);
DROP TRIGGER startup_tr;
COMMIT;
CREATE OR REPLACE TRIGGER startup_tr
AFTER LOGON OR STARTUP ON DATABASE
BEGIN
    INSERT INTO CONNECTIONS_LOG (USER_NAME, EVENT_TYPE, LOGON_DATE, LOGON_TIME, LOGOFF_DATE, LOGOFF_TIME)
    VALUES (USER, ORA_SYSEVENT, SYSDATE, TO_CHAR(SYSDATE, 'hh24:mi:ss'), NULL, NULL);
    COMMIT;
END;
/
--* 20. log off triggers
--* SEQUENCES to create autoincrement values
CREATE SEQUENCE my_sequence
  START WITH 1
  INCREMENT BY 1;

CREATE OR REPLACE TRIGGER my_table_trigger
  BEFORE INSERT ON CONNECTIONS_LOG
  FOR EACH ROW
BEGIN
  SELECT my_sequence.NEXTVAL
  INTO :NEW.LOG_ID
  FROM DUAL;
END;
/
CREATE OR REPLACE TRIGGER SHUTDOWN_tr
BEFORE LOGOFF ON DATABASE
BEGIN
   UPDATE CONNECTIONS_LOG
   SET LOGOFF_DATE = SYSDATE,
       LOGOFF_TIME = TO_CHAR(SYSDATE, 'hh24:mi:ss')
   WHERE USER_NAME = USER
     AND LOG_ID = (SELECT MAX(LOG_ID) FROM CONNECTIONS_LOG WHERE USER_NAME = USER);
END;
/
SELECT TO_TIMESTAMP(LOGON_TIME,'HH24:MI:SS')-TO_TIMESTAMP(LOGOFF_TIME,'HH24:MI:SS') FROM CONNECTIONS_LOG;

-- * 21. Startup triggers 
--! Added OR STARTUP Into logon trigger: See line 317 

-- *  22.Instead of Insert Trigger 
--? instead of triggers can be used to update tables from a view.
--? usually this will genereate an error as views are virtual tables
--? but with instead of triggers you can force the update of the underlying tables
--? from the view
CREATE TABLE developers (
    dev_id NUMBER,
    dev_name VARCHAR(200),
    skill_id NUMBER
);
CREATE TABLE SKILLS(
    skill_id NUMBER,
    skill_name VARCHAR (20)
);
INSERT INTO DEVELOPERS VALUES (1,'Miguel',1);
INSERT INTO DEVELOPERS VALUES (1,'Miguel',2);
INSERT INTO DEVELOPERS VALUES (1,'Miguel',3);
INSERT INTO SKILLS VALUES (1,'SQL');
INSERT INTO SKILLS VALUES (2,'TABLEAU');
INSERT INTO SKILLS VALUES (3,'PYTHON');
COMMIT;

CREATE OR REPLACE VIEW devs_skills as
SELECT DEV_ID,DEV_NAME,d.SKILL_ID, SKILL_NAME  AS FROM DEVELOPERS d
INNER JOIN SKILLS s ON d.skill_id=s.skill_id;
SELECT * FROM Devs_skills;
-- Instead of trigger
CREATE OR REPLACE TRIGGER tr_insteadof_insert
INSTEAD OF INSERT ON devs_skills
FOR EACH ROW
BEGIN
    INSERT INTO DEVELOPERS VALUES(:new.dev_id,:new.dev_name,:new.skill_id);        
    INSERT INTO SKILLS VALUES(:new.skill_id,:new.skill_name); 
END;
/   
INSERT INTO DEVS_SKILLS VALUES(1,'Miguel',4,'PL/SQL');
INSERT INTO DEVS_SKILLS VALUES(1,'Miguel',5,'ALTERYX');
INSERT INTO DEVS_SKILLS VALUES(1,'Miguel',6,'ALTERYX');
SELECT * FROM DEVS_SKILLS;
--* 23. INSTEAD OF UPDATE
CREATE OR REPLACE TRIGGER insteadof_update
INSTEAD OF UPDATE ON DEVS_SKILLS
FOR EACH ROW
BEGIN
    UPDATE SKILLS SET SKILL_NAME= :new.SKILL_NAME
    WHERE SKILL_ID = :old.SKILL_ID;
END;
    
UPDATE DEVS_SKILLS SET SKILL_NAME='PYTHON' WHERE SKILL_ID=1 ; --SET :NEW.  WHERE :OLD.
SELECT * FROM DEVS_SKILLS;
COMMIT;
--*24. Instead of DELETE triggers
--*26. Introduction to Cursors
--Cursors : Pointer to a memory area that holds info about processing of SELECT or DML
-- implicit and explicit cursors
-- EXAMPLE USECASE OF CURSORS
--! DECLARE: initializes cursor into memory
DECLARE
   -- Cursor to fetch total sales for each salesperson for the current month
   CURSOR sales_cursor IS
      SELECT salesperson_id, SUM(sale_amount) AS total_sales
      FROM sales
      WHERE sale_date BETWEEN TRUNC(SYSDATE, 'MM') AND LAST_DAY(SYSDATE)
      GROUP BY salesperson_id;
   -- Variables to hold data fetched from the cursor
   v_salesperson_id sales.salesperson_id%TYPE;
   v_total_sales sales.sale_amount%TYPE;
   v_bonus salespersons.bonus%TYPE;
BEGIN
   -- ! OPEN: In order to put the cursor to work we have to open
   OPEN sales_cursor;
   -- Loop through each row returned by the cursor
   LOOP
    --! FETCH : the process of retrieving the data from the cursor
      FETCH sales_cursor INTO v_salesperson_id, v_total_sales; -- ? you can fetch variables as well as records
      EXIT WHEN sales_cursor%NOTFOUND;
      v_bonus := v_total_sales * 0.05;
      UPDATE salespersons
      SET bonus = v_bonus
      WHERE salesperson_id = v_salesperson_id;
   END LOOP;
   -- ! CLOSE 
   CLOSE sales_cursor;
   COMMIT;
END;
--* 27. EXPLICIT CURSOR EXAMPLE
DECLARE
  V_DEV_ID NUMBER;
  v_DEV_NAME VARCHAR2(20);
  V_SKILL_NAME VARCHAR2(20);

  CURSOR cursor_27 IS
  SELECT DEV_ID,DEV_NAME,SKILL_NAME FROM DEVS_SKILLS;
BEGIN
  OPEN CURSOR_27;
  LOOP
    FETCH CURSOR_27 INTO V_DEV_ID,V_DEV_NAME,V_SKILL_NAME;
    EXIT WHEN cursor_27%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('DEV #' || V_DEV_ID ||' '||V_DEV_NAME||' Has Skill: '||V_SKILL_NAME);
  END LOOP;
  CLOSE CURSOR_27;
END;
/
--* 28. PARAMETRIZED CURSORS
-- you can pass parameters just as we do for functions for cursors
declare
    i_SKILL VARCHAR2(20);
    i_SKILL_id NUMBER;
    v_dev_id NUMBER :=2;
    v_dev_NAME VARCHAR2(20) :='Maria';
    CURSOR cursor_28(v_dev_id NUMBER ,v_dev_NAME VARCHAR2) IS 
    SELECT SKILL_ID,SKILL_NAME FROM SKILLS; 
BEGIN
    OPEN cursor_28 (v_dev_id,v_dev_NAME) ;
    LOOP
        FETCH CURSOR_28 INTO I_SKILL_id,I_SKILL;
        EXIT WHEN cursor_28%NOTFOUND;
        INSERT INTO DEVS_SKILLS VALUES(v_dev_id,V_DEV_NAME,I_SKILL_ID,I_SKILL);
        --DBMS_OUTPUT.PUT_LINE(v_dev_id||V_DEV_NAME||I_SKILL_ID||I_SKILL);
    END LOOP;
    CLOSE cursor_28;
END;
SELECT DISTINCT * FROM DEVS_SKILLS ORDER BY DEV_ID ASC; 
COMMIt;
-- *29. Parametrized CURSOR with default value
DECLARE
    v2_skill_id NUMBER;
    v_skill_name VARCHAR2(25);
    CURSOR cursor_29(v_skill_id NUMBER := 1)
    IS
        SELECT *
        FROM SKILLS
        WHERE skill_id >= v_skill_id;
BEGIN
    OPEN cursor_29(3); -- If no value is passed, in this case (3) then it grabs the default (1)
    
    LOOP
        FETCH cursor_29 INTO v2_skill_id, v_skill_name;
        EXIT WHEN cursor_29%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v2_skill_id || v_skill_name);
    END LOOP;
    
    CLOSE cursor_29;
END;

SET SERVEROUTPUT ON;
DECLARE
    CURSOR new_emps(v_emp_no NUMBER) IS
        SELECT * FROM EMPLOYEES
        WHERE emp_no>v_emp_no;
 BEGIN
    FOR i IN new_emps(10001)
   LOOP
     DBMS_OUTPUT.PUT_LINE(i.EMP_NO|| ' ' || i.FIRST_NAME);
   END LOOP;
 END;

--37. records in pl/sql
DECLARE
    TYPE rv_emp IS RECORD(
        v_emp_no  EMPLOYEES.EMP_NO%TYPE,
        f_name  EMPLOYEES.FIRST_NAME%TYPE,
        l_name EMPLOYEES.LAST_NAME%TYPE
    );-- Creates row data type 
    var1 rv_emp;-- then assign a single row as a variable
BEGIN
    SELECT EMP_NO,FIRST_NAME,LAST_NAME 
    INTO var1.v_EMP_NO,var1.F_NAME,var1.L_NAME
    FROM employees
    WHERE EMP_NO=10001;
    DBMS_OUTPUT.PUT_LINE(var1.f_name || var1.l_name);
END;
-- 40. Stored Procedures - can be likened to Macros
-- Procedures does not return any values, Functions do.
-- Create a stored procedure to insert a new employee record into an employees table.
CREATE OR REPLACE PROCEDURE insert_employee 
    (V_EMP_NO   IN  employees.EMP_NO%TYPE, 
    V_BIRTH_DATE IN employees.BIRTH_DATE%TYPE ,
    V_FIRST_NAME IN employees.FIRST_NAME%TYPE ,
    V_LAST_NAME  IN employees.LAST_NAME %TYPE ,
    V_GENDER     IN employees.GENDER%TYPE ,
    V_HIRE_DATE  IN employees.HIRE_DATE%type)
IS
BEGIN
    INSERT INTO employees 
    (EMP_NO,BIRTH_DATE,FIRST_NAME,LAST_NAME, GENDER,HIRE_DATE)
    VALUES   
    (V_EMP_NO,V_BIRTH_DATE,V_FIRST_NAME,V_LAST_NAME, V_GENDER,V_HIRE_DATE);
END insert_employee;

SET SERVEROUTPUT ON;
EXECUTE insert_employee(10050,'06/05/98','Maria','Osuna','F','27/06/24');
ALTER TRIGGER  EMPLOYEES_AUDIT DISABLE;
COMMIT;

--39.functions 
-- create a function that takes the employee id and returns the annual salary
DESC salaries;
INSERT INTO 
    SALARIES (EMP_NO, SALARY, FROM_DATE, TO_DATE)
VALUES
    (10001, 48000, TO_DATE('09/07/2024', 'DD/MM/YYYY'), TO_DATE('31/12/9999', 'DD/MM/YYYY'));
INSERT INTO 
    SALARIES (EMP_NO, SALARY, FROM_DATE, TO_DATE)
VALUES    
    (10001, 43000, TO_DATE('22/02/2023', 'DD/MM/YYYY'), TO_DATE('31/12/9999', 'DD/MM/YYYY'));
INSERT INTO 
    SALARIES (EMP_NO, SALARY, FROM_DATE, TO_DATE)
VALUES
    (10001, 25000, TO_DATE('11/02/2022', 'DD/MM/YYYY'), TO_DATE('31/12/9999', 'DD/MM/YYYY'));
SELECT * FROM SALARIES;

CREATE OR REPLACE FUNCTION get_curr_salary (v_emp_no IN NUMBER)
RETURN NUMBER IS
    v_salary NUMBER;
BEGIN
     SELECT SALARY INTO v_salary 
    FROM SALARIES
    WHERE EMP_NO= v_emp_no AND
    FROM_DATE= (SELECT MAX(FROM_DATE)FROM SALARIES WHERE EMP_NO=V_EMP_NO);
    RETURN v_salary;
END;
SELECT get_curr_salary(10001)FROM DUAL;

SET SERVEROUTPUT ON;
DECLARE
    v_emp_no NUMBER := 10059;
    v_employee EMPLOYEES%ROWTYPE;
BEGIN
    SELECT *
    INTO v_employee
    FROM EMPLOYEES
    WHERE emp_no = v_emp_no;
    DBMS_OUTPUT.PUT_LINE('Employee: ' || v_employee.emp_no || ', ' || v_employee.first_name || ' ' || v_employee.last_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;

--* 46. Exception handling
-- system defined exception: oracle created these 
--& user-defined Exceptions: raised explicitly in the PL/sql Block
-- 1. variable of eXCEPTION datatype
-- 2. using PRAGMA exception_INIT function 
-- 3. USING RAISE_APPLICATION_ERROR
-- *47. declaring exception variable
DECLARE 
    var_dividend NUMBER := 24;
    var_divisor NUMBER :=6;
    Var_result NUMBER ;
    ex_DivZero EXCEPTION;
BEGIN
    if var_divisor =0 THEN
        RAISE ex_DivZero;
    END IF;
    var_result:= var_dividend/var_divisor;
    DBMS_OUTPUT.PUT_LINE('Result is: ' || var_result);

    EXCEPTION WHEN ex_DivZero THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: Your Divisor is Zero');
END;
--* 48. Using RAISE_APPLICATION_ERROR
DECLARE
    age NUMBER :=12;
BEGIN
    if age<18 then
    RAISE_APPLICATION_ERROR(-20008,'You should be 18 or above for the Drinks');
    -- -20000 to -20999 are options for user defined errors
    END IF;
    DBMS_OUTPUT.PUT_LINE('Sure what would you like to Drink?');
    EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- * 49. using PRAGMA EXCEPTION_INIT
ACCEPT var_age NUMBER PROMPT 'What is your Age?'; -- USer input interface, not working on VScode tho :(
DECLARE 
    v_age NUMBER :=&var_age;
    ex_age EXCEPTION ;
    PRAGMA EXCEPTION_INIT(ex_age,-20008);
BEGIN
    if v_age<18 THEN
        RAISE_APPLICATION_ERROR(-20008,'You should be 18 or above for the Drinks');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Sure what would you like to Drink?');

    EXCEPTION WHEN ex_age THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
end;

-- * 50. PL/SQL Collections
--nested tables, VARRAY, Associative Array 
-- * 51. Nested tables: a table inside of another table
-- creating a nested table as collection
DECLARE
    type nested_table IS TABLE of NUMBER;
    var_nt nested_table := nested_table(1,5,4,22,12,9,8);
BEGIN
    FOR i in var_nt.FIRST ..var_nt.LAST -- kind of like looping a list in python
    LOOP
        DBMS_OUTPUT.PUT_LINE(var_nt(i)**2 ); 
    END LOOP; 
END;

-- * 52. Nested table as database object
-- so you can use it however you want in the db
CREATE OR REPLACE TYPE my_table IS TABLE OF VARCHAR(10);
/
DECLARE
    t my_table := my_table('a','l','c','m','p');
    n_row NUMBER;
BEGIN 
    FOR i in t.FIRST .. t.LAST
    LOOP
        SELECT COUNT(*) INTO n_row FROM DRIVERS
            WHERE FORENAME  LIKE UPPER(t(i))||'%';
        DBMS_OUTPUT.PUT_LINE('List of Drivers which name Starts with: '|| UPPER(t(i)));
        FOR j IN (SELECT FORENAME|| ' ' ||SURNAME AS name FROM DRIVERS
            WHERE FORENAME  LIKE UPPER(t(i))||'%'  ORDER BY name ASC)
        LOOP
            DBMS_OUTPUT.PUT_LINE(j.name);
        END LOOP;
        
            DBMS_OUTPUT.PUT_LINE('There are '|| TO_CHAR(n_row)|| ' Drivers whose name starts with ' || UPPER(t(i)));
    END LOOP;
END;

CREATE TABLE  MY_SUBJECT (
    SUB_ID NUMBER,
    SUB_NAME VARCHAR2(20),
    sub_schedule_day my_table
) NESTED TABLE sub_schedule_day STORE AS nested_tab_space;
COMMIT;
DESC MY_SUBJECT;
INSERT INTO MY_SUBJECT (SUB_ID,SUB_NAME,sub_schedule_day)
VALUES (1,'Math',my_table('MON','WED','FRI')); 
INSERT INTO MY_SUBJECT (SUB_ID,SUB_NAME,sub_schedule_day)
VALUES (2,'Physics',my_table('TUE','THU')); 
INSERT INTO MY_SUBJECT (SUB_ID,SUB_NAME,sub_schedule_day)
VALUES (3,'Chemistry',my_table('MON','WED','FRI')); 
INSERT INTO MY_SUBJECT (SUB_ID,SUB_NAME,sub_schedule_day)
VALUES (4,'History',my_table('FRI')); 

SELECT SUB_SCHEDULE_DAY FROM MY_SUBJECT;
--* 53. Nested tables using user defined datatypes


-- PL/SQL Tips and Techniques
--* 1.Use the compile time warnings feature of PL/SQL
--* 2.Don't repeat anything
--  aim for a single point of definition for everything in your aplication
--* keep your executable sections tiny
-- spaghetti code is the kiss of death for maintainable code.
-- * Key performance optimization tips
-- Avoid row by row processing of non query DML statements: Lowest hanging fruit for major performance improvement
-- Leverage the function result cache
