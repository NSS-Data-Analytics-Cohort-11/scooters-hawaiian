--770 null values in chargelevel column found in scooters table
--10018 rows in scooter table
--still has trips less than 1 minute (9154 rows)
--merge on sumdid column 

--time period for trip table 92 days
SELECT MAX(enddate) - MIN(startdate) AS duration
FROM trips

SELECT Min(startdate) 
FROM trips

--time period for scooters table 91 days
SELECT MAX(pubdatetime) - MIN(pubdatetime) AS duration
FROM scooters

--time is represented in 24hrs in scooters pubdatetime column and trips pubtmestamp column


SELECT COUNT(distinct sumdid), companyname
FROM scooters
WHERE sumdgroup <> 'bicycle'
GROUP BY companyname
--scooters table company names:	"Bird"	"Bolt"	"Gotcha" "Jump"	"Lime"	"Lyft"	"Spin"
-- -- Number of scooters?
-- 3860	"Bird"
-- 360	"Bolt"
-- 224	"Gotcha"
-- 1210	"Jump"
-- 1818	"Lime"
-- 1735	"Lyft"
-- 805	"Spin"


SELECT COUNT(companyname), companyname
FROM trips
GROUP BY companyname

-- -- Number of scooters? from the trips table
-- 152745	"Bird"
-- 21890	"Bolt Mobility"
-- 3315	"Gotcha"
-- 6437	"JUMP"
-- 225694	"Lime"
-- 120991	"Lyft"
-- 34450	"SPIN"

--Scooter is also spelled scooter and there are bicycles in the sumdgroup which we can exclude from our analysis
SELECT DISTINCT(sumdgroup)
FROM scooters


SELECT COUNT(sumdtype), sumdtype
FROM scooters
GROUP BY sumdtype


--trips less than 1 min
select count(companyname),companyname
from trips
where tripduration <1
group by companyname
-- 3963	"Bird"
-- 661	"Lime"
-- 4530	"Lyft"



--trips greater than 24hrs
select count(companyname),companyname
from trips
where tripduration >1440
group by companyname
-- 6908	"Bolt Mobility"
-- 2	"Lyft"
-- 28	"SPIN"







--QUESTION 1
WITH month_1 AS (SELECT companyname, COUNT(sumdid) AS may
FROM (SELECT companyname, sumdid, to_char(pubtimestamp, 'MM/DD/YY')::date AS date_time
FROM trips)
WHERE date_time < '06/01/2019' AND date_time > '05/01/2019'
GROUP BY companyname
ORDER BY may DESC),
	month_2 AS (SELECT companyname, COUNT(sumdid) AS june
FROM (SELECT companyname, sumdid, to_char(pubtimestamp, 'MM/DD/YY')::date AS date_time
FROM trips)
WHERE date_time < '07/01/2019' AND date_time > '06/01/2019'
GROUP BY companyname
ORDER BY june DESC),
	month_3 AS (SELECT companyname, COUNT(sumdid) AS july
FROM (SELECT companyname, sumdid, to_char(pubtimestamp, 'MM/DD/YY')::date AS date_time
FROM trips)
WHERE date_time < '08/01/2019' AND date_time > '07/01/2019'				
GROUP BY companyname
ORDER BY july DESC)SELECT *, SUM(may + june + july) AS total_usage
FROM (SELECT *
FROM month_1
FULL JOIN month_2
USING(companyname)
FULL JOIN month_3
USING(companyname))
GROUP BY companyname, may, june, july
ORDER BY total_usage DESC
-- --ANSWER
-- "Lime"			102180	79972	37301	219453
-- "Bird"			52357	52394	42143	146894
-- "Lyft"			53169	35480	28141	116790
-- "SPIN"			8452	13190	11503	33145
-- "Bolt Mobility"	4889	9297	6606	20792
-- "JUMP"			600		1741	4047	6388
-- "Gotcha"			650		1645	859		3154



--Previous date specs result
-- "Lime"	98786	78333	36260	213379
-- "Bird"	50685	48799	41249	140733
-- "Lyft"	51882	34131	27378	113391
-- "SPIN"	7842	12792	11313	31947
-- "Bolt Mobility"	4316	9001	6482	19799
-- "JUMP"	600	1741	3969	6310
-- "Gotcha"	517	1645	859	3021















SELECT pubtimestamp, companyname, sumdid, startdate, starttime, enddate, endtime, startlatitude, startlongitude, endlatitude, endlongitude
FROM trips
WHERE tripduration BETWEEN 1 AND 1440


-- --Q3
-- with usage_per_day as(
-- 	select companyname,
-- 		   sumdid as scooter_ID,
-- 		   cast(pubtimestamp as date) as date,
-- 		   count(*) as trips_per_scooter
-- 	from trips
-- 	where tripduration between 1 and 1440
-- 	group by date, sumdid, companyname
-- 	--having count(*) >= 3
-- 	order by date, companyname), -- this CTE gives you the count of trips per scooter type, per company, per date
	
-- 	avg_per_day as(
-- 	select companyname,
-- 		   avg(trips_per_scooter) as avg_trips_per_scooter,
-- 		   date
-- 	from usage_per_day
-- 	group by date, companyname
-- 	order by date, companyname) -- this CTE is attached to the 1st one and it gives you the avg trips per scooter, per company, per date
-- ------------------------------------------------------------------------------------------
-- charged_scooters AS(
-- 	select *
-- 	from scooters
-- 	where chargelevel > 0 AND chargelevel notnull
-- 			)

-- select companyname, avg(avg_trips_per_scooter) as total_avg_scooter_trips
-- from avg_per_day
-- FULL JOIN charged_scooters
-- USING(sumdid)
-- group by companyname
-- order by companyname  -- this MAIN Query gives you the total average scooter trips per company
-- -- --ANSWER
-- -- "Bird"	1.85003737842772272778
-- -- "Bolt Mobility"	1.8464552289275451
-- -- "Gotcha"	2.20508004407105770545
-- -- "JUMP"	39.87647109343293355510
-- -- "Lime"	3.99753548754437786087
-- -- "Lyft"	2.79628776729803033978
-- -- "SPIN"	1.92434071044459232785


--QUESTION 3
with usage_per_day as(
	select companyname,
		   sumdid,
		   cast(pubtimestamp as date) as date,
		   count(*) as trips_per_scooter
	from trips
	where tripduration between 1 and 1440
	group by date, sumdid, companyname
	--having count(*) >= 3
	order by date, companyname), -- this CTE gives you the count of trips per scooter type, per company, per date
	
	avg_per_day as(
	select companyname,sumdid,
		   avg(trips_per_scooter) as avg_trips_per_scooter,
		   date
	from usage_per_day
	group by date, companyname, sumdid
	order by date, companyname) -- this CTE is attached to the 1st one and it gives you the avg trips per scooter, per company, per date
------------------------------------------------------------------------------------------
select avg_per_day.companyname,ROUND(avg(avg_trips_per_scooter),2) as total_avg_scooter_trips
from avg_per_day
full join scooters
USING(sumdid)
where chargelevel > 0 AND chargelevel notnull
group by avg_per_day.companyname
order by avg_per_day.companyname  
--ANSWER
-- "Bird"	1.92
-- "Bolt Mobility"	1.97
-- "Gotcha"	2.46
-- "JUMP"	1.50
-- "Lime"	4.13
-- "Lyft"	2.90
-- "SPIN"	2.08




--Q3 edit:TAKES LONG TO RUN
-- with usage_per_day as(
-- 	select companyname,
-- 		   sumdid,
-- 		   cast(pubtimestamp as date) as date,
-- 		   count(*) as trips_per_scooter
-- 	from trips
-- 	where tripduration between 1 and 1440
-- 	group by date, sumdid, companyname
-- 	--having count(*) >= 3
-- 	order by date, companyname), -- this CTE gives you the count of trips per scooter type, per company, per date
	
-- 	avg_per_day as(
-- 	select companyname,sumdid,
-- 		   avg(trips_per_scooter) as avg_trips_per_scooter,
-- 		   date
-- 	from usage_per_day
-- 	group by date, companyname, sumdid
-- 	order by date, companyname) -- this CTE is attached to the 1st one and it gives you the avg trips per scooter, per company, per date
-- ------------------------------------------------------------------------------------------
-- select avg_per_day.companyname,scooters.sumdid, Round(avg(avg_trips_per_scooter),2) as total_avg_scooter_trips
-- from avg_per_day
-- full join scooters
-- USING(sumdid)
-- where chargelevel > 0 AND chargelevel notnull
-- group by avg_per_day.companyname, scooters.sumdid
-- order by avg_per_day.companyname  
-- limit 10
-- "Bird"	"Powered11MUW"	1.00
-- "Bird"	"Powered11XTN"	1.60
-- "Bird"	"Powered125HI"	1.88
-- "Bird"	"Powered12J9T"	1.84
-- "Bird"	"Powered12PSS"	1.56
-- "Bird"	"Powered13HXH"	2.00
-- "Bird"	"Powered13WNI"	2.27
-- "Bird"	"Powered142KL"	2.07
-- "Bird"	"Powered14477"	1.82
-- "Bird"	"Powered145AD"	1.20


--QUESTION 4
--1585 scooters being used at 11:57pm
select to_char(starttime, 'HH24:MI') as hour_and_minute, count(*) as scooter_count
from trips
where tripduration between 1 and 1440
group by hour_and_minute
order by scooter_count desc, hour_and_minute

select to_char(starttime, 'HH24') as hour_and_minute, count(*) as scooter_count
from trips
where tripduration between 1 and 1440
group by hour_and_minute
order by scooter_count desc, hour_and_minute



SELECT * FROM trips LIMIT 1000
SELECT * FROM scooters LIMIT 1000  order by pubdatetime desc 