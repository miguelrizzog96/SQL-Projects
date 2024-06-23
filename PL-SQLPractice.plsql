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

-- STRUCTURE OF A PL/SQL BLOCK
DECLARE
    -- Declaration section: variables, constants, cursors, etc.
    variable_name datatype [NOT NULL := value]; --Variables: Declared with a name and data type. Can be initialized with a default value.
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
BEGIN
    -- Use SELECT INTO to fetch the department name
    BEGIN
        -- Fetch the department name for the given employee
        SELECT d.DEPT_NAME 
        INTO v_dept_name
        FROM dept_emp de 
        INNER JOIN DEPARTMENTS d ON de.DEPT_NO = d.DEPT_NO
        WHERE de.EMP_NO = v_emp_no;

        -- Compare the fetched department name with the given department name
        IF v_dept_name = v_dept THEN
            UPDATE salaries 
            SET salary = salary * 1.1  
            WHERE EMP_NO = v_emp_no;
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

