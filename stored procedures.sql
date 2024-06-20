-- stored procedures
USE f1db;
DROP PROCEDURE IF EXISTS select_champions;

DELIMITER $$
CREATE PROCEDURE select_champions()
BEGIN
    SELECT t1.* FROM
    (SELECT concat(forename,' ',surname) as driver, year, MAX(points) as points 
    FROM drivers d
    INNER JOIN driverStandings ds ON d.driverId=ds.driverId
    INNER JOIN races r ON r.raceId=ds.raceId
    GROUP BY concat(forename,' ',surname),year
    )t1
    INNER JOIN  
            (SELECT  year, MAX(points) as points 
            FROM drivers d
            INNER JOIN driverStandings ds ON d.driverId=ds.driverId
            INNER JOIN races r ON r.raceId=ds.raceId
            GROUP BY year) t2
        ON t1.points=t2.points and t1.year=t2.year
        WHERE t1.year!=year(CURDATE())
    ORDER BY t1.year DESC;
END$$
DELIMITER ;
CALL select_champions();

DROP PROCEDURE IF EXISTS circuits_in_country;
DELIMITER $$
USE f1db $$
CREATE PROCEDURE circuits_in_country(IN in_country VARCHAR(64))
BEGIN 
 SELECT name, country,location
 FROM circuits
 WHERE UPPER(country)= UPPER(in_country);
END$$
DELIMITER ;

CALL circuits_in_country('USA');

DROP PROCEDURE IF EXISTS avg_points_per_race;
DELIMITER $$
CREATE PROCEDURE avg_points_per_race (IN in_driver_name VARCHAR(254),IN in_season INTEGER , OUT avg_points DECIMAL (10,2))
BEGIN
SELECT AVG(points)
INTO avg_points
FROM results re
INNER JOIN drivers d
ON re.driverId=d.driverId
INNER JOIN races r
ON re.raceId=r.raceId
WHERE CONCAT(forename,' ',surname)= in_driver_name
AND in_season=year;
END$$
DELIMITER ;

SET @v_avg_points = 0;
CALL f1db.avg_points_per_race('Charles Leclerc',2021,@v_avg_salary);
SELECT @v_avg_salary;

DROP FUNCTION IF EXISTS f_points_per_race;
DELIMITER $$
CREATE FUNCTION f_points_per_race(in_driver_name VARCHAR (255),in_season INTEGER )  RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN 
DECLARE v_points_race DECIMAL(10,2);
SELECT AVG(points)
INTO v_points_race
FROM results re
INNER JOIN drivers d
ON re.driverId=d.driverId
INNER JOIN races r
ON re.raceId=r.raceId
WHERE CONCAT(forename,' ',surname)= in_driver_name
AND in_season=year;
RETURN v_points_race;
END$$

SELECT f_points_per_race('Nico Rosberg',2015);
    