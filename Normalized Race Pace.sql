SELECT r.name,Driver,dl.name AS Team,r.year as season,round,Laps_completed, N_laps,
       avg_pace_driver,Avg_race_pace,Stdev_race, (avg_pace_driver-Avg_race_pace)/Stdev_race as zscore,
       CONCAT(r.year,"-",round) as a

FROM(
SELECT raceId, 
       driverId, 
       AVG(milliseconds) / 1000 as avg_pace_driver,
       AVG(AVG(milliseconds)/1000) OVER (PARTITION BY raceId) as Avg_race_pace ,
       STDDEV(STDDEV(milliseconds)/1000) OVER (PARTITION BY raceId) as Stdev_race
FROM lapTimes

GROUP BY raceId, driverId ) t1
INNER JOIN (SELECT driverId,raceId,COUNT(Lap) as Laps_completed FROM laptimes
              GROUP BY driverId,raceId) t2
ON t1.raceId=t2.raceId AND t1.driverId=t2.driverId
INNER JOIN races r ON t1.raceId=r.raceId
INNER JOIN drivers d ON d.driverId=t1.driverId
INNER JOIN driverlineups dl ON CONCAT(d.forename,' ',d.surname)=dl.Driver
INNER JOIN (SELECT raceId,MAX(Lap) as N_laps FROM laptimes GROUP BY raceId) t5
ON t5.raceId=t1.raceId
AND r.year=dl.year
WHERE r.year BETWEEN 2010 and 2023
AND N_laps*0.95 <= Laps_completed
ORDER BY season, round ;