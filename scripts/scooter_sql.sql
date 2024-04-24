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

--trips greater than 24hrs
select count(companyname),companyname
from trips
where tripduration <1
group by companyname



SELECT pubtimestamp, companyname, sumdid, startdate, starttime, enddate, endtime, startlatitude, startlongitude, endlatitude, endlongitude
FROM trips
WHERE tripduration BETWEEN 1 AND 1440


--Q3
with usage_per_day as(
	select companyname,
		   sumdid as scooter_ID,
		   cast(pubtimestamp as date) as date,
		   count(*) as trips_per_scooter
	from trips
	where tripduration between 1 and 1440
	group by date, sumdid, companyname
	--having count(*) >= 3
	order by date, companyname), -- this CTE gives you the count of trips per scooter type, per company, per date
	
	avg_per_day as(
	select companyname,
		   avg(trips_per_scooter) as avg_trips_per_scooter,
		   date
	from usage_per_day
	group by date, companyname
	order by date, companyname) -- this CTE is attached to the 1st one and it gives you the avg trips per scooter, per company, per date
------------------------------------------------------------------------------------------
select companyname, avg(avg_trips_per_scooter) as total_avg_scooter_trips
from avg_per_day
group by companyname
order by companyname  -- this MAIN Query gives you the total average scooter trips per company
-- --ANSWER
-- "Bird"	1.85003737842772272778
-- "Bolt Mobility"	1.8464552289275451
-- "Gotcha"	2.20508004407105770545
-- "JUMP"	39.87647109343293355510
-- "Lime"	3.99753548754437786087
-- "Lyft"	2.79628776729803033978
-- "SPIN"	1.92434071044459232785




SELECT * FROM trips LIMIT 1000
SELECT * FROM scooters LIMIT 1000  order by pubdatetime desc 