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
--If the department is 'Sales', give the employee a bonus of 10% of their salary. If not, print a message saying no bonus.
DECLARE
    v_emp_no NUMBER := 10002;
    v_dept VARCHAR2(50) := 'Sales';
    v_dept_name VARCHAR2(50);

BEGIN
    -- Use SELECT INTO to fetch the department name
    BEGIN
        SELECT d.DEPT_NAME 
        INTO v_dept_name
        FROM dept_emp de 
        INNER JOIN DEPARTMENTS d ON de.DEPT_NO = d.DEPT_NO
        WHERE de.EMP_NO = v_emp_no;

        -- Use the fetched department name in the IF condition
        IF v_dept_name = v_dept THEN
            DBMS_OUTPUT.PUT_LINE('THERE is bonus for this employee :)');
        ELSE
            DBMS_OUTPUT.PUT_LINE('no bonus for this employee :(');
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Employee or Department not found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
    END;
END;

--Exercise 3: Looping
--Write a PL/SQL block that retrieves all employee IDs 
--from the employees table and prints each one using a loop.
BEGIN
    FOR i IN (SELECT EMP_NO FROM employees)
        LOOP
            DBMS_OUTPUT.PUT_LINE('EMPLOYEE_ID: ' || i.EMP_NO);
        END LOOP;
END;