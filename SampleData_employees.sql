-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;

-- shows only the current department for each employee
-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE OR REPLACE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;
        

COMMIT;

-- Inserting multiple rows into the employees table
INSERT INTO employees --(emp_no, birth_date, first_name, last_name, gender, hire_date)
-- First row
SELECT 10001, TO_DATE('1953-09-02', 'YYYY-MM-DD'), 'Georgi', 'Facello', 'M', TO_DATE('1986-06-26', 'YYYY-MM-DD') FROM dual
UNION ALL
-- Second row
SELECT 10002, TO_DATE('1964-06-02', 'YYYY-MM-DD'), 'Bezalel', 'Simmel', 'F', TO_DATE('1985-11-21', 'YYYY-MM-DD') FROM dual
UNION ALL
-- Third row
SELECT 10003, TO_DATE('1959-12-03', 'YYYY-MM-DD'), 'Parto', 'Bamford', 'M', TO_DATE('1986-08-28', 'YYYY-MM-DD') FROM dual;
COMMIT;
-- Insert into dept_emp table
INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date)
VALUES (10001, 'd005', TO_DATE('1986-06-26', 'YYYY-MM-DD'), TO_DATE('9999-01-01', 'YYYY-MM-DD'));

INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date)
VALUES (10002, 'd007', TO_DATE('1996-08-03', 'YYYY-MM-DD'), TO_DATE('9999-01-01', 'YYYY-MM-DD'));

INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date)
VALUES (10003, 'd004', TO_DATE('1995-12-03', 'YYYY-MM-DD'), TO_DATE('9999-01-01', 'YYYY-MM-DD'));

-- Insert into titles table
INSERT INTO titles (emp_no, title, from_date, to_date)
VALUES (10001, 'Senior Engineer', TO_DATE('1986-06-26', 'YYYY-MM-DD'), TO_DATE('9999-01-01', 'YYYY-MM-DD'));

INSERT INTO titles (emp_no, title, from_date, to_date)
VALUES (10002, 'Staff', TO_DATE('1996-08-03', 'YYYY-MM-DD'), TO_DATE('9999-01-01', 'YYYY-MM-DD'));

INSERT INTO titles (emp_no, title, from_date, to_date)
VALUES (10003, 'Senior Engineer', TO_DATE('1995-12-03', 'YYYY-MM-DD'), TO_DATE('9999-01-01', 'YYYY-MM-DD'));

-- Insert into salaries table
INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 60117, TO_DATE('1986-06-26', 'YYYY-MM-DD'), TO_DATE('1987-06-26', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 62102, TO_DATE('1987-06-26', 'YYYY-MM-DD'), TO_DATE('1988-06-25', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 66074, TO_DATE('1988-06-25', 'YYYY-MM-DD'), TO_DATE('1989-06-25', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 66596, TO_DATE('1989-06-25', 'YYYY-MM-DD'), TO_DATE('1990-06-25', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 66961, TO_DATE('1990-06-25', 'YYYY-MM-DD'), TO_DATE('1991-06-25', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 71046, TO_DATE('1991-06-25', 'YYYY-MM-DD'), TO_DATE('1992-06-24', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 74333, TO_DATE('1992-06-24', 'YYYY-MM-DD'), TO_DATE('1993-06-24', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 75286, TO_DATE('1993-06-24', 'YYYY-MM-DD'), TO_DATE('1994-06-24', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 75994, TO_DATE('1994-06-24', 'YYYY-MM-DD'), TO_DATE('1995-06-24', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 76884, TO_DATE('1995-06-24', 'YYYY-MM-DD'), TO_DATE('1996-06-23', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 80013, TO_DATE('1996-06-23', 'YYYY-MM-DD'), TO_DATE('1997-06-23', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 81025, TO_DATE('1997-06-23', 'YYYY-MM-DD'), TO_DATE('1998-06-23', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 81097, TO_DATE('1998-06-23', 'YYYY-MM-DD'), TO_DATE('1999-06-23', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 84917, TO_DATE('1999-06-23', 'YYYY-MM-DD'), TO_DATE('2000-06-22', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 85112, TO_DATE('2000-06-22', 'YYYY-MM-DD'), TO_DATE('2001-06-22', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 85097, TO_DATE('2001-06-22', 'YYYY-MM-DD'), TO_DATE('2002-06-22', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10001, 88958, TO_DATE('2002-06-22', 'YYYY-MM-DD'), TO_DATE('9999-01-01', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10002, 65828, TO_DATE('1996-08-03', 'YYYY-MM-DD'), TO_DATE('1997-08-03', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10002, 65909, TO_DATE('1997-08-03', 'YYYY-MM-DD'), TO_DATE('1998-08-03', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10002, 67534, TO_DATE('1998-08-03', 'YYYY-MM-DD'), TO_DATE('1999-08-03', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10002, 69366, TO_DATE('1999-08-03', 'YYYY-MM-DD'), TO_DATE('2000-08-02', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10002, 71963, TO_DATE('2000-08-02', 'YYYY-MM-DD'), TO_DATE('2001-08-02', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10002, 72527, TO_DATE('2001-08-02', 'YYYY-MM-DD'), TO_DATE('9999-01-01', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10003, 40006, TO_DATE('1995-12-03', 'YYYY-MM-DD'), TO_DATE('1996-12-02', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10003, 43616, TO_DATE('1996-12-02', 'YYYY-MM-DD'), TO_DATE('1997-12-02', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10003, 43466, TO_DATE('1997-12-02', 'YYYY-MM-DD'), TO_DATE('1998-12-02', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10003, 43636, TO_DATE('1998-12-02', 'YYYY-MM-DD'), TO_DATE('1999-12-02', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10003, 43478, TO_DATE('1999-12-02', 'YYYY-MM-DD'), TO_DATE('2000-12-01', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10003, 43699, TO_DATE('2000-12-01', 'YYYY-MM-DD'), TO_DATE('2001-12-01', 'YYYY-MM-DD'));

INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES (10003, 43311, TO_DATE('2001-12-01', 'YYYY-MM-DD'), TO_DATE('9999-01-01', 'YYYY-MM-DD'));


SELECT * FROM titles;
COMMIT; -- Commit changes if everything executes successfully

INSERT INTO departments 
 SELECT 'd001','Marketing' FROM dual
 UNION ALL

 SELECT 'd002','Finance' FROM dual
 UNION ALL

 SELECT 'd003','Human Resources' FROM dual
 UNION ALL

 SELECT 'd004','Production' FROM dual
 UNION ALL

 SELECT 'd005','Development' FROM dual
 UNION ALL

 SELECT 'd006','Quality Management' FROM dual
 UNION ALL

 SELECT 'd007','Sales' FROM dual
 UNION ALL

 SELECT 'd008','Research' FROM dual
 UNION ALL

 SELECT 'd009','Customer Service' FROM dual;

 Commit;