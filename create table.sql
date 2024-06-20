DROP TABLE users;
CREATE TABLE users(
    user_id NUMBER CONSTRAINT c1 PRIMARY KEY   CONSTRAINT c2 NOT NULL,
    username VARCHAR2 (256),
    first_name VARCHAR2 (256),
    Last_name VARCHAR2 (256)
);
INSERT INTO users 
VALUES(1,'Miguelr96','Miguel Angel','Rizzo Gonzalez');

SELECT * from USERS;