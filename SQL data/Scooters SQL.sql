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


SELECT MAX(pubdatetime), MIN(pubdatetime)
FROM scooters

WITH app_cost AS (SELECT((CASE WHEN p.price::MONEY <= 1::MONEY THEN 10000::MONEY 
	   		  ELSE (CAST(p.price AS MONEY) * 10000) END AS app_cost))) AS app_cost 

SELECT MIN(date::date), MAX(date::date)
FROM(SELECT to_char(pubdatetime, 'MM/DD/YY') AS date
FROM scooters)
 
-- 1: During this period, seven companies offered scooters. How many scooters did each company have in this time frame? 
--Did the number for each company change over time? Did scooter usage vary by company?
SELECT COUNT(DISTINCT companyname) 
FROM scooters
--
SELECT companyname, COUNT(companyname) AS comp_count
FROM (SELECT DISTINCT(sumdid), companyname
FROM scooters)
GROUP BY companyname
ORDER BY comp_count DESC
--Part 1: Here shows all company and the number of scooters they have
SELECT companyname, COUNT(companyname) AS comp_count
FROM (SELECT DISTINCT(sumdid), companyname
FROM (SELECT sumdid, companyname, to_char(pubdatetime, 'MM/DD/YY')::date AS date_time
FROM scooters)
WHERE date_time <= '05/31/2019')
GROUP BY companyname
ORDER BY comp_count DESC

SELECT companyname, COUNT(companyname) AS comp_count
FROM (SELECT DISTINCT(sumdid), companyname
FROM (SELECT sumdid, companyname, to_char(pubdatetime, 'MM/DD/YY')::date AS date_time
FROM scooters)
WHERE date_time <= '06/30/2019')
GROUP BY companyname
ORDER BY comp_count DESC

WITH month_1 AS (
	SELECT companyname, COUNT(companyname) AS comp_count
FROM (SELECT DISTINCT(sumdid), companyname
FROM (SELECT sumdid, companyname, to_char(pubdatetime, 'MM/DD/YY')::date AS date_time
FROM scooters)
WHERE date_time <= '05/31/2019')
GROUP BY companyname
ORDER BY comp_count DESC),
	month_2 AS (SELECT companyname, COUNT(companyname) AS comp_count
FROM (SELECT DISTINCT(sumdid), companyname
FROM (SELECT sumdid, companyname, to_char(pubdatetime, 'MM/DD/YY')::date AS date_time
FROM scooters)
WHERE date_time <= '06/30/2019')
GROUP BY companyname
ORDER BY comp_count DESC),
	month_3 AS (SELECT companyname, COUNT(companyname) AS comp_count
FROM (SELECT DISTINCT(sumdid), companyname
FROM scooters)
GROUP BY companyname
ORDER BY comp_count DESC)

SELECT * 
FROM month_1
FULL JOIN month_2 
USING(companyname)
FULL JOIN month_3
USING(companyname)
--Part2: They all have some growth over the 3 months but Bird has the greatest gain over this time
SELECT *
FROM trips
LIMIT 1


WITH month_1 AS (SELECT companyname, COUNT(sumdid) AS id_count
FROM (SELECT companyname, sumdid, to_char(pubtimestamp, 'MM/DD/YY')::date AS date_time
FROM trips)
WHERE date_time <= '05/31/2019'
GROUP BY companyname
ORDER BY id_count DESC),
	month_2 AS (SELECT companyname, COUNT(sumdid) AS id_count
FROM (SELECT companyname, sumdid, to_char(pubtimestamp, 'MM/DD/YY')::date AS date_time
FROM trips)
WHERE date_time <= '06/30/2019'
GROUP BY companyname
ORDER BY id_count DESC),
	month_3 AS (SELECT companyname, COUNT(sumdid) AS id_count
FROM (SELECT companyname, sumdid, to_char(pubtimestamp, 'MM/DD/YY')::date AS date_time
FROM trips)
GROUP BY companyname
ORDER BY id_count DESC)

SELECT * 
FROM month_1
FULL JOIN month_2 
USING(companyname)
FULL JOIN month_3
USING(companyname)
--Part3: Here how the use of the 1st month, 1st and 2nd, and all the months

-- --According to Second Substitute Bill BL2018-1202 (as amended) (https://web.archive.org/web/20181019234657/https://www.nashville.gov/Metro-Clerk/Legislative/Ordinances/Details/7d2cf076-b12c-4645-a118-b530577c5ee8/2015-2019/BL2018-1202.aspx), all permitted operators will first clean data before providing or reporting data to Metro. Data processing and cleaning shall include:
-- Removal of staff servicing and test trips
-- Removal of trips below one minute
-- Trip lengths are capped at 24 hours
-- Are the scooter companies in compliance with the second and third part of this rule?























