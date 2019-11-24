select count(*) from [dbo].[311-Public-Data-Extract-2017-clean]

--Loading only harris county data
select * into data311_2017 
from [dbo].[311-Public-Data-Extract-2017-clean]
where lower(county) like 'harris%' 

select * from [dbo].[311-Public-Data-Extract-2017-clean]  where isnumeric(latitude ) <> 1

select distinct latitude from data311_2017   where isnumeric(latitude ) <> 1

select distinct longitude from data311_2017   where isnumeric(latitude ) <> 1


select distinct "sr type" from data311_2017  order by "sr type"
select distinct "SR CREATE DATE" from data311_2017   where isdate("SR CREATE DATE" ) <> 1

select count(*) from data311_2017 



select count(*) from data311_2017   where  sla='' or overdue='' or "due date"=''
select count(*) from data311_2017   where  latitude ='' or longitude='' or "SR Type"='' or "SR Create DATE"='' or STATUS=''

--removing data where latitude, longitude, sr type, sr create date or status is blank
select * into data311_2017_v1 from data311_2017   where not(latitude ='' or longitude='' or "SR Type"='' or "SR Create DATE"='' or STATUS='' )

insert into [dbo].[hou311_2017_cleaned]
select * from data311_2017_v1

--calculating eucledean distance to all police stations
select  d.*
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat1*PI()/180)*cos(long1*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat1*PI()/180)*sin(long1*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat1*PI()/180))) as d1
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat2*PI()/180)*cos(long2*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat2*PI()/180)*sin(long2*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat2*PI()/180))) as d2
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat3*PI()/180)*cos(long3*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat3*PI()/180)*sin(long3*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat3*PI()/180))) as d3
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat4*PI()/180)*cos(long4*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat4*PI()/180)*sin(long4*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat4*PI()/180))) as d4
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat5*PI()/180)*cos(long5*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat5*PI()/180)*sin(long5*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat5*PI()/180))) as d5
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat6*PI()/180)*cos(long6*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat6*PI()/180)*sin(long6*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat6*PI()/180))) as d6
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat7*PI()/180)*cos(long7*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat7*PI()/180)*sin(long7*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat7*PI()/180))) as d7
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat8*PI()/180)*cos(long8*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat8*PI()/180)*sin(long8*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat8*PI()/180))) as d8
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat9*PI()/180)*cos(long9*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat9*PI()/180)*sin(long9*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat9*PI()/180))) as d9
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat10*PI()/180)*cos(long10*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat10*PI()/180)*sin(long10*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat10*PI()/180))) as d10
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat11*PI()/180)*cos(long11*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat11*PI()/180)*sin(long11*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat11*PI()/180))) as d11
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat12*PI()/180)*cos(long12*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat12*PI()/180)*sin(long12*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat12*PI()/180))) as d12
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat13*PI()/180)*cos(long13*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat13*PI()/180)*sin(long13*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat13*PI()/180))) as d13
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat14*PI()/180)*cos(long14*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat14*PI()/180)*sin(long14*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat14*PI()/180))) as d14
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat15*PI()/180)*cos(long15*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat15*PI()/180)*sin(long15*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat15*PI()/180))) as d15
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat16*PI()/180)*cos(long16*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat16*PI()/180)*sin(long16*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat16*PI()/180))) as d16
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat17*PI()/180)*cos(long17*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat17*PI()/180)*sin(long17*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat17*PI()/180))) as d17
,sqrt(square(6371*cos(latitude*PI()/180)*cos(longitude*PI()/180)- 6371*cos(lat18*PI()/180)*cos(long18*PI()/180))+
square(6371*cos(latitude*PI()/180)*sin(longitude*PI()/180) - 6371*cos(lat18*PI()/180)*sin(long18*PI()/180))
+ square(6371*sin(latitude*PI()/180)- 6371*sin(lat18*PI()/180))) as d18
into police_2017_cleaned
from hou311_2017_cleaned d cross join latlongpolicestations l

--finding nearest police station
SELECT h.*, disnearestpolst
into police_2017_cleaned_distince
FROM police_2017_cleaned h
CROSS APPLY (SELECT MIN(d) disnearestpolst FROM (VALUES (d1), (d2), (d3), (d4), (d5), (d6), (d7), (d8), (d9), (d10), 
(d11), (d12), (d13), (d14), (d15), (d16), (d17), (d18)) AS a(d)) A

select * from police_2017_cleaned

select * from hou311_2017_cleaned
