select count(*) from [dbo].[Merged_Houston311_Storm_rec_2018]

delete from Merged_Houston311_Storm_rec_2018 where isnumeric(latitude) <>1 or isnumeric(longitude)<>1
CREATE TABLE [dbo].[Merged_Houston311_Storm_rec_Police_2018](
	[CASE NUMBER] [varchar](50) NULL,
	[SR LOCATION] [varchar](200) NULL,
	[COUNTY] [varchar](50) NULL,
	[DISTRICT] [varchar](50) NULL,
	[NEIGHBORHOOD] [varchar](50) NULL,
	[TAX ID] [varchar](50) NULL,
	[TRASH QUAD] [varchar](50) NULL,
	[RECYCLE QUAD] [varchar](50) NULL,
	[TRASH DAY] [varchar](50) NULL,
	[HEAVY TRASH DAY] [varchar](50) NULL,
	[RECYCLE DAY] [varchar](50) NULL,
	[KEY MAP] [varchar](50) NULL,
	[MANAGEMENT DISTRICT] [varchar](50) NULL,
	[DEPARTMENT] [varchar](50) NULL,
	[DIVISION] [varchar](50) NULL,
	[SR TYPE] [varchar](50) NULL,
	[QUEUE] [varchar](50) NULL,
	[SLA] [varchar](50) NULL,
	[STATUS] [varchar](50) NULL,
	[SR CREATE DATE] datetime NULL,
	[DUE DATE] [varchar](50) NULL,
	[DATE CLOSED] [varchar](50) NULL,
	[OVERDUE] [varchar](50) NULL,
	[Title] [varchar](200) NULL,
	[x] [varchar](50) NULL,
	[y] [varchar](50) NULL,
	[LATITUDE] decimal(18,10) NULL,
	[LONGITUDE] decimal(18,10) NULL,
	[Channel Type] [varchar](50) NULL,
	[weatherflag] int NULL,
	[eventType] [varchar](50) NULL,
	[Nearest_facility] decimal(18,10) NULL
) ON [PRIMARY]
GO

insert into Merged_Houston311_Storm_rec_Police_2018
select * from Merged_Houston311_Storm_rec_2018

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
into #police_2018_cleaned
from Merged_Houston311_Storm_rec_Police_2018 d cross join latlongpolicestations l


SELECT h.*, disnearestpolst, case when disnearestpolst<=2 then 1 else 0 end as "polStLessThan2km"
into Merged_Houston311_Storm_rec_PoliceDistance_2018
FROM #police_2018_cleaned h
CROSS APPLY (SELECT MIN(d) disnearestpolst FROM (VALUES (d1), (d2), (d3), (d4), (d5), (d6), (d7), (d8), (d9), (d10), 
(d11), (d12), (d13), (d14), (d15), (d16), (d17), (d18)) AS a(d)) A

SELECT [CASE NUMBER]
      ,[SR LOCATION]
      ,[COUNTY]
      ,[DISTRICT]
      ,[NEIGHBORHOOD]
      ,[TAX ID]
      ,[TRASH QUAD]
      ,[RECYCLE QUAD]
      ,[TRASH DAY]
      ,[HEAVY TRASH DAY]
      ,[RECYCLE DAY]
      ,[KEY MAP]
      ,[MANAGEMENT DISTRICT]
      ,[DEPARTMENT]
      ,[DIVISION]
      ,[SR TYPE]
      ,[QUEUE]
      ,[SLA]
      ,[STATUS]
      ,[SR CREATE DATE]
      ,[DUE DATE]
      ,[DATE CLOSED]
      ,[OVERDUE]
      ,[Title]
      ,[x]
      ,[y]
      ,[LATITUDE]
      ,[LONGITUDE]
      ,[Channel Type]
      ,[weatherflag]
      ,[eventType]
      ,[Nearest_facility]
      ,[disnearestpolst]
      ,[polStLessThan2km]
  FROM [dbo].[Merged_Houston311_Storm_rec_PoliceDistance_2018]
  where 1=2
							     
