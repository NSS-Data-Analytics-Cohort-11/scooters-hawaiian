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
-- SELECT companyname, COUNT(companyname) AS comp_count
-- FROM (SELECT DISTINCT(sumdid), companyname
-- FROM (SELECT sumdid, companyname, to_char(pubdatetime, 'MM/DD/YY')::date AS date_time
-- FROM scooters)
-- WHERE date_time <= '05/31/2019')
-- GROUP BY companyname
-- ORDER BY comp_count DESC

-- SELECT companyname, COUNT(companyname) AS comp_count
-- FROM (SELECT DISTINCT(sumdid), companyname
-- FROM (SELECT sumdid, companyname, to_char(pubdatetime, 'MM/DD/YY')::date AS date_time
-- FROM scooters)
-- WHERE date_time <= '06/30/2019')
-- GROUP BY companyname
-- ORDER BY comp_count DESC
SELECT * 
FROM scooters 
LIMIT 1

WITH month_1 AS (
	SELECT companyname, COUNT(companyname) AS may
FROM (SELECT DISTINCT(sumdid), companyname
FROM (SELECT sumdid, companyname, to_char(pubdatetime, 'MM/DD/YY')::date AS date_time
FROM scooters
WHERE sumdgroup != 'bicycle')
WHERE date_time < '05/31/2019')
GROUP BY companyname
ORDER BY may DESC),
	month_2 AS (
	SELECT companyname, COUNT(companyname) AS may_june
FROM (SELECT DISTINCT(sumdid), companyname
FROM (SELECT sumdid, companyname, to_char(pubdatetime, 'MM/DD/YY')::date AS date_time
FROM scooters
WHERE sumdgroup != 'bicycle')
WHERE date_time < '06/30/2019')
GROUP BY companyname
ORDER BY may_june DESC),
	month_3 AS (
	SELECT companyname, COUNT(companyname) AS may_june_july
FROM (SELECT DISTINCT(sumdid), companyname
FROM (SELECT sumdid, companyname, to_char(pubdatetime, 'MM/DD/YY')::date AS date_time
FROM scooters
WHERE sumdgroup != 'bicycle')
WHERE date_time < '07/31/2019')
GROUP BY companyname
ORDER BY may_june_july DESC)


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


WITH month_1 AS (SELECT companyname, COUNT(sumdid) AS may
FROM (SELECT companyname, sumdid, to_char(pubtimestamp, 'MM/DD/YY')::date AS date_time
FROM trips)
WHERE date_time < '05/31/2019' AND date_time > '05/01/2019'
GROUP BY companyname
ORDER BY may DESC),
	month_2 AS (SELECT companyname, COUNT(sumdid) AS june
FROM (SELECT companyname, sumdid, to_char(pubtimestamp, 'MM/DD/YY')::date AS date_time
FROM trips)
WHERE date_time < '06/30/2019' AND date_time > '06/01/2019'
GROUP BY companyname
ORDER BY june DESC),
	month_3 AS (SELECT companyname, COUNT(sumdid) AS july
FROM (SELECT companyname, sumdid, to_char(pubtimestamp, 'MM/DD/YY')::date AS date_time
FROM trips)
WHERE date_time < '07/31/2019' AND date_time > '07/01/2019'				
GROUP BY companyname
ORDER BY july DESC)

SELECT *, SUM(may + june + july) AS total_usage
FROM (SELECT * 
FROM month_1
FULL JOIN month_2 
USING(companyname)
FULL JOIN month_3
USING(companyname))
GROUP BY companyname, may, june, july
ORDER BY total_usage DESC
--Part3: Here how the use of the 1st month, 1st and 2nd, and all the months

-- --According to Second Substitute Bill BL2018-1202 (as amended) (https://web.archive.org/web/20181019234657/https://www.nashville.gov/Metro-Clerk/Legislative/Ordinances/Details/7d2cf076-b12c-4645-a118-b530577c5ee8/2015-2019/BL2018-1202.aspx), all permitted operators will first clean data before providing or reporting data to Metro. Data processing and cleaning shall include:
-- Removal of staff servicing and test trips
-- Removal of trips below one minute
-- Trip lengths are capped at 24 hours
-- Are the scooter companies in compliance with the second and third part of this rule?

SELECT companyname, COUNT(companyname) 
FROM trips
WHERE tripduration < 1 OR tripduration > 1440
GROUP BY companyname
-- They are not in compliance with the second and third parts of the rules and tthere are over 16000 data points that show either a time of less then a minute (1) or ones that go well over 24 hours (1440)

--The goal of Metro Nashville is to have each scooter used a minimum of 3 times per day. Based on the data, what is the average number of trips per scooter per day? Make sure to consider the days that a scooter was available. How does this vary by company?

SELECT date_time, COUNT(sumdid)
FROM(SELECT *, to_char(pubdatetime, 'MM/DD/YY')::date AS date_time
FROM scooters)
GROUP BY date_time

SELECT * 
FROM trips
LIMIT 100

--charge level 

-- SELECT companyname, COUNT(companyname) 
-- FROM trips
-- WHERE tripduration < 1 OR tripduration > 1440
-- GROUP BY companyname

SELECT DISTINCT(companyname), ROUND(AVG(trips_taken),0) AS avg_trips_taken
FROM(SELECT companyname, date_time, sumdid, COUNT(sumdid) AS trips_taken
FROM(SELECT companyname, date_time, sumdid
FROM(SELECT *, to_char(pubtimestamp, 'MM/DD/YY')::date AS date_time
FROM trips
WHERE tripduration > 1 OR tripduration < 1440))
GROUP BY companyname,date_time, sumdid)
GROUP BY companyname

-- SELECT COUNT(DISTINCT triprecordnum), COUNT(DISTINCT sumdid), COUNT(DISTINCT triprecordnum) / COUNT(DISTINCT sumdid)  
-- FROM trips
-- WHERE companyname = 'Lime'

--Metro would like to know how many scooters are needed, and something that could help with this is knowing peak demand. 
--Estimate the highest count of scooters being used at the same time. 
--When were the highest volume times? 
--Does this vary by zip code or other geographic region?

SELECT DISTINCT(triprecordnum),pubtimestamp
FROM trips



