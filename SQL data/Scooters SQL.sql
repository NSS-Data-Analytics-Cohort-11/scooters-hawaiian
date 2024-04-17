SELECT COUNT(*)
FROM scooters

--73414043

SELECT COUNT(*)
FROM trips
--565522

SELECT *
FROM scooters
WHERE latitude = NULL

SELECT MAX(pubdatetime) - MIN(pubdatetime)
FROM scooters
-- 92 days 

SELECT MAX(pubtimestamp) - MIN(pubtimestamp)
FROM trips
-- 92 days

SELECT DISTINCT(sumdgroup)
FROM scooters
--bicycle
SELECT COUNT(sumdgroup)
FROM scooters
WHERE sumdgroup = 'bicycle'
--26529 data for bicycles

SELECT sumdgroup
FROM scooters
WHERE sumdgroup != 'scooter'
LIMIT 100

SELECT latitude, longitude
FROM scooters
WHERE latitude > 42
LIMIT 1000
--After 42 tthe Lat goes into the 360000
SELECT latitude, longitude
FROM scooters
WHERE longitude > -78
LIMIT 1000
--After -79 the Latt and long got 0
SELECT DISTINCT companyname
FROM scooters
UNION ALL
SELECT DISTINCT companyname
FROM trips
--The names are the same but more structed in the scooters table








