select *
from scooters
limit 10

select *
from trips
limit 10

---------------------------------------------- 

/* - Are there any null values in any columns in either table? */
 
select count(*) as total_number_of_null
from scooters
where pubdatetime IS NULL  /*0*/

select count(*) as total_number_of_null
from scooters
where latitude IS NULL /*0*/

select count(*) as total_number_of_null
from scooters
where longitude IS NULL  /*0*/

select count(*) as total_number_of_null
from scooters
where sumdid IS NULL	/*0*/

select count(*) as total_number_of_null
from scooters
where sumdtype IS NULL   /*0*/

select count(*) as total_number_of_null
from scooters
where chargelevel IS NULL  /*770 NULLS*/

select count(*) as total_number_of_null
from scooters
where sumdgroup IS NULL  /*0*/

select count(*) as total_number_of_null
from scooters
where costpermin IS NULL  /*0*/

select count(*) as total_number_of_null
from scooters
where companyname IS NULL  /*0*/



select count(*) as total_number_of_null
from trips
where pubtimestamp IS NULL
OR companyname IS NULL
or triprecordnum IS NULL
or sumdid IS NULL
or tripduration IS NULL
or tripdistance IS NULL				/* 0 null values*/
or startdate IS NULL
or starttime IS NULL
or enddate IS NULL
or endtime IS NULL
or startlatitude IS NULL
or startlongitude IS NULL
or endlatitude IS NULL
or endlongitude IS NULL
or triproute IS NULL
or create_dt IS NULL

--------------------------------------------------------------------

/* - What date range is represented in each of the date columns? Investigate any values that seem odd. */

select 
	min(pubdatetime) as first_date,
	max(pubdatetime) as last_date
from scooters



select 
	min(pubtimestamp) as first_date, 
	max(pubtimestamp) as last_date
from trips

select 
	min(startdate) as first_date, 
	max(startdate) as last_date
from trips

select 
	min(enddate) as first_date, 
	max(enddate) as last_date
from trips

select 
	min(create_dt) as first_date, 
	max(create_dt) as last_date
from trips

--------------------------------------------------------------------

/* - Is time represented with am/pm or using 24 hour values in each of the columns that include time? */

select *
from scooters
limit 10  /* pubdatetime uses 24 HR values*/

select pubtimestamp, starttime, endtime
from trips
limit 5000 /* pubtimestamp, starttime, endtime uses 24 HR values*/

--------------------------------------------------------------------

/* - What values are there in the sumdgroup column? Are there any that are not of interest for this project? */

select distinct sumdgroup
from scooters
/* bicycle, scooter, Scooter values are listed. Bicycles are irrelevant to our project. */

--------------------------------------------------------------------

/* - What are the minimum and maximum values for all the latitude and longitude columns? Do these ranges make sense, or is there anything surprising? */

select *
from trips
limit 10

select
	max(latitude) as max_lat,
	min(latitude) as min_lat,
	max(longitude) as max_lon, 
	min(longitude) as min_lon
from scooters


select	
	max(startlatitude) as max_start_lat,   /*looks to be that they started around the same latitude*/
	min(startlatitude) as min_start_lat,
	max(endlatitude) as max_end_lat,		/*max latitude and min latitude are very different*/
	min(endlatitude) as min_end_lat,
	
	max(startlongitude) as max_start_lon,   /*looks to be that they started around the same longitude*/
	min(startlongitude) as min_start_lon,
	max(endlongitude) as max_end_lon,       /*max longitude and min longitude are very different*/
	min(endlongitude) as min_end_lon	
from trips

--------------------------------------------------------------------

/* - What is the range of values for trip duration and trip distance? Do these values make sense? Explore values that might seem questionable. */

select 
	min(tripduration) as min_duration,
	max(tripduration) as max_duration,
	min(tripdistance) as min_distance,
	max(tripdistance) as max_distance
from trips				/* negatives on the min durations and distances... why? */

--------------------------------------------------------------------

/* - Check out how the values for the company name column in the scooters table compare to those of the trips table. What do you notice? */

WITH companyname_scooters AS

(
select companyname as companyname_scooters
from scooters
group by companyname
), 

companyname_trips AS

(
select companyname as companyname_trips
from trips
group by companyname
)

SELECT companyname_scooters, companyname_trips
FROM companyname_scooters
INNER JOIN companyname_trips
ON (companyname)

--------------------------------------------------------------------

/* 1. During this period, seven companies offered scooters. How many scooters did each company have in this time frame? Did the number for each company change over time? Did scooter usage vary by company? */


/* below query gives us each company name listed in the table*/
select companyname as companyname_scooters
from scooters
group by companyname

/* below query gives us total number of scooters - 10012 total scooters */
select count(distinct sumdid)    
from scooters 					
where sumdgroup ilike 'scooter'

/* below query shows the number of scooters per company*/
SELECT
	companyname, 
	COUNT(distinct sumdid) as number_of_scooters_per_company
FROM scooters
WHERE sumdgroup ilike 'scooter'
GROUP BY companyname


select 
	count(distinct sumdid) as scooter_id,
	companyname,
	to_char(pubdatetime, 'MM/DD/YY')::date as date_time
from scooters
-- where pubdatetime <= '05/31/2019' 
group by companyname, date_time



WITH May_scooters AS

(	SELECT
		companyname, 
		COUNT(distinct scooter_id) as number_of_scooters_for_May
	FROM (select companyname, sumdid as scooter_id, to_char(pubdatetime, 'MM/DD/YY')::date as date_time from scooters where sumdgroup ilike 'scooter')
 	WHERE date_time <= '05/31/2019'
 	GROUP BY companyname
),

June_scooters AS

(	SELECT
		companyname, 
		COUNT(distinct scooter_id) as number_of_scooters_for_June
	FROM (select companyname, sumdid as scooter_id, to_char(pubdatetime, 'MM/DD/YY')::date as date_time from scooters where sumdgroup ilike 'scooter')
 	WHERE date_time BETWEEN '06/01/2019' AND '06/30/2019'
 	GROUP BY companyname
),

July_scooters AS

(	SELECT
		companyname, 
		COUNT(distinct scooter_id) as number_of_scooters_for_July
	FROM (select companyname, sumdid as scooter_id, to_char(pubdatetime, 'MM/DD/YY')::date as date_time from scooters where sumdgroup ilike 'scooter')
 	WHERE date_time >= '07/01/2019'
	GROUP BY companyname
)

SELECT *
FROM May_scooters
FULL JOIN June_scooters
USING (companyname)
FULL JOIN July_scooters
USING (companyname)



select 
	companyname,
	sumdid as scooter_id,
	to_char(pubdatetime, 'MM/DD/YY')::date as date_time
from scooters
limit 10


	
		























