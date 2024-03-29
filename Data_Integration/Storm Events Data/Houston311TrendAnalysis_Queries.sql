  -- Query to aggregate 311 call counts for each month over last three years 
  select ltrim(rtrim(concat(year([SR CREATE DATE]), case when len(month([SR CREATE DATE]))=1 then concat('0',month([SR CREATE DATE])) else cast(month([SR CREATE DATE]) as char) 
	end))) year_month,
	year([SR CREATE DATE]) call_year,
	month([SR CREATE DATE]) call_month,
	count(*) no_of_calls
    FROM [dbo].[Houston_311]
	group by   ltrim(rtrim(concat(year([SR CREATE DATE]), case when len(month([SR CREATE DATE]))=1 then concat('0',month([SR CREATE DATE])) else cast(month([SR CREATE DATE]) as char) 
	end))),
	year([SR CREATE DATE]) ,
	month([SR CREATE DATE]) 
	order by ltrim(rtrim(concat(year([SR CREATE DATE]), case when len(month([SR CREATE DATE]))=1 then concat('0',month([SR CREATE DATE])) else cast(month([SR CREATE DATE]) as char) 
	end))),
	year([SR CREATE DATE]) ,
	month([SR CREATE DATE])

-- Query to aggregate 311 call counts for each day 
SELECT cast([SR CREATE DATE] as date) [SR CREATE DATE]
      
	  ,year(cast([SR CREATE DATE] as date)) as call_year
	  ,month(cast([SR CREATE DATE] as date)) as call_month
	  ,day(cast([SR CREATE DATE] as date)) as call_day
	  ,weatherflag
	  ,count(*) call_count
  FROM [dbo].[Houston_311]
  group by cast([SR CREATE DATE] as date),year(cast([SR CREATE DATE] as date))
	  ,month(cast([SR CREATE DATE] as date)),
	  day(cast([SR CREATE DATE] as date)) ,
	  weatherflag
  order by cast([SR CREATE DATE] as date)

 -- Query to find top three complaint types on a perticluar day
  select *,year(cast([SR CREATE DATE] as date)) as call_year,
  month(cast([SR CREATE DATE] as date)) as call_month,
  day(cast([SR CREATE DATE] as date)) as call_day
  from 
  (
  select [SR CREATE DATE], [SR TYPE], count_sr_type,
  row_number() over (partition by [SR CREATE DATE] order by [SR CREATE DATE],count_sr_type desc ) rank_no
  from
  (
  SELECT cast([SR CREATE DATE] as date) [SR CREATE DATE],
  [SR TYPE],
  count(*) count_sr_type
   FROM [dbo].[Houston_311]
   group by cast([SR CREATE DATE] as date),
   [SR TYPE]
   --order by cast([SR CREATE DATE] as date),
   --count(*) desc
   )c
   )o
  where rank_no<=3
  order by [SR CREATE DATE] 


