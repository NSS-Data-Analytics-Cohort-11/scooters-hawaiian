select *
from scooters
limit 10

select *
from trips
limit 10

---------------------------------------------- 
 
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

-------------------------------------------------------------------- 

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

select *
from scooters
limit 10  /* pubdatetime uses 24 HR values*/

select pubtimestamp, starttime, endtime
from trips
limit 5000 /* pubtimestamp, starttime, endtime uses 24 HR values*/

--------------------------------------------------------------------

select distinct sumdgroup
from scooters
/* bicycle, scooter, Scooter values are listed. Bicycles are irrelevant to our prohject. */

--------------------------------------------------------------------

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

select 
	min(tripduration) as min_duration,
	max(tripduration) as max_duration,
	min(tripdistance) as min_distance,
	max(tripdistance) as max_distance
from trips				/* negatives on the min durations and distances... why? */

--------------------------------------------------------------------

WITH companynames AS

(
select distinct companyname as companyname_scooters
from scooters

union all

select distinct companyname as companyname_trips
from trips
)

select companyname_scooters, companyname_trips
from companynames





