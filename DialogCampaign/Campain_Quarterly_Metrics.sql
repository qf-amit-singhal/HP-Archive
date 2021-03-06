--SELECT * FROM [dbo].[Monthly_Metrics_Campaign_List]
--select convert(varchar(7), [Start_Date], 120) from [Monthly_Metrics_Campaign_List]

DECLARE @ReportMonth varchar(8) 

DECLARE @QuarterStart varchar(8),
        @QuarterEnd varchar(8);

SET @QuarterStart = '2022-01';
SET @QuarterEnd = '2022-03';


select 1 as Sort, 'Cumulative: # of active campaigns (Eloqua)' as Descr, count(distinct [Campaign_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) <= @QuarterEnd
  and ([End_Date] is null or convert(varchar(7), [End_Date], 120) >= @QuarterStart)
  and [Campaign_Type] = 'ACTIVE'
  and [Campaign_Name] is not null
union all  
select 2 as Sort, 'Cumulative: # of active email messages (Eloqua)' as Descr, count(distinct [Email_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) <= @QuarterEnd
  and ([End_Date] is null or convert(varchar(7), [End_Date], 120) >= @QuarterStart)
  and [Campaign_Type] = 'ACTIVE'
  and [Email_Name] is not null
union all  
select 3 as Sort, 'Cumulative: # of new campaigns (Eloqua)' as Descr, count(distinct [Campaign_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) between @QuarterStart and @QuarterEnd
  and [Campaign_Type] = 'ACTIVE'
  and [Campaign_Name] is not null
union all  
select 4 as Sort, 'Cumulative: # of new active email messages (Eloqua)' as Descr, count(distinct [Email_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) between @QuarterStart and @QuarterEnd
  and [Campaign_Type] = 'ACTIVE'
  and [Email_Name] is not null
union all  
select 5 as Sort, 'Cumulative: # of adhoc campaigns (Eloqua)' as Descr, count(distinct [Campaign_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) between @QuarterStart and @QuarterEnd
  and [Campaign_Type] = 'ADHOC'
  and [Campaign_Name] is not null
order by Sort