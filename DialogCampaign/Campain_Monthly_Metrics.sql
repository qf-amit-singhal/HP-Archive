--SELECT * FROM [dbo].[Monthly_Metrics_Campaign_List]
--select convert(varchar(7), [Start_Date], 120) from [Monthly_Metrics_Campaign_List]

--truncate table [dbo].[Monthly_Metrics_Campaign_List]

DECLARE @ReportMonth varchar(8) 

SET @ReportMonth = '2022-01'

select 1 as Sort, 'Cumulative: # of active campaigns (Eloqua)' as Descr, count(distinct [Campaign_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) <= @ReportMonth
  --and ([End_Date] is null or convert(varchar(7), [End_Date], 120) >= @ReportMonth)
  and ([End_Date] is null or convert(varchar(7), [End_Date], 120) >= '2022-01')
  and [Campaign_Type] = 'ACTIVE'
  and [Campaign_Name] is not null
union all  
select 2 as Sort, 'Cumulative: # of active email messages (Eloqua)' as Descr, count(distinct [Email_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) <= @ReportMonth
  --and ([End_Date] is null or convert(varchar(7), [End_Date], 120) >= @ReportMonth)
  and ([End_Date] is null or convert(varchar(7), [End_Date], 120) >= '2022-01')
  and [Campaign_Type] = 'ACTIVE'
  and [Email_Name] is not null
union all  
select 3 as Sort, 'Cumulative: # of new campaigns (Eloqua)' as Descr, count(distinct [Campaign_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) between '2022-01' and @ReportMonth
  and [Campaign_Type] = 'ACTIVE'
  and [Campaign_Name] is not null
union all  
select 4 as Sort, 'Cumulative: # of new active email messages (Eloqua)' as Descr, count(distinct [Email_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) between '2022-01' and @ReportMonth
  and [Campaign_Type] = 'ACTIVE'
  and [Email_Name] is not null
union all  
select 5 as Sort, 'Cumulative: # of adhoc campaigns (Eloqua)' as Descr, count(distinct [Campaign_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) between '2022-01' and @ReportMonth
  and [Campaign_Type] = 'ADHOC'
  and [Campaign_Name] is not null
order by Sort



select 1 as Sort, '# of active campaigns (Eloqua)' as Descr, count(distinct [Campaign_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) <= @ReportMonth
  and ([End_Date] is null or convert(varchar(7), [End_Date], 120) >= @ReportMonth)
  and [Campaign_Type] = 'ACTIVE'
  and [Campaign_Name] is not null
union all  
select 2 as Sort, '# of active email messages (Eloqua)' as Descr, count(distinct [Email_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) <= @ReportMonth
  and ([End_Date] is null or convert(varchar(7), [End_Date], 120) >= @ReportMonth)
  and [Campaign_Type] = 'ACTIVE'
  and [Email_Name] is not null
union all  
select 3 as Sort, '# of new campaigns (Eloqua)' as Descr, count(distinct [Campaign_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) = @ReportMonth
  and [Campaign_Type] = 'ACTIVE'
  and [Campaign_Name] is not null
union all  
select 4 as Sort, '# of new active email messages (Eloqua)' as Descr, count(distinct [Email_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) = @ReportMonth
  and [Campaign_Type] = 'ACTIVE'
  and [Email_Name] is not null
union all  
select 5 as Sort, '# of adhoc campaigns (Eloqua)' as Descr, count(distinct [Campaign_Name]) as Total
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) = @ReportMonth
  and [Campaign_Type] = 'ADHOC'
  and [Campaign_Name] is not null
order by Sort



select distinct '# of active campaigns (Eloqua)', Campaign_Name, Start_Date, End_Date, Campaign_Type
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) <= @ReportMonth
  and ([End_Date] is null or convert(varchar(7), [End_Date], 120) >= @ReportMonth)
  and [Campaign_Type] = 'ACTIVE'
  and [Campaign_Name] is not null

select distinct '# of active email messages (Eloqua)' as Descr, [Email_Name], Start_Date, End_Date, Campaign_Type
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) <= @ReportMonth
  and ([End_Date] is null or convert(varchar(7), [End_Date], 120) >= @ReportMonth)
  and [Campaign_Type] = 'ACTIVE'
  and [Email_Name] is not null

select distinct '# of new campaigns (Eloqua)', Campaign_Name, Start_Date, End_Date, Campaign_Type
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) = @ReportMonth
  and [Campaign_Type] = 'ACTIVE'
  and [Campaign_Name] is not null

select distinct '# of new active email messages (Eloqua)' as Descr, [Email_Name], Start_Date, End_Date, Campaign_Type
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) = @ReportMonth
  and [Campaign_Type] = 'ACTIVE'
  and [Email_Name] is not null

select distinct '# of adhoc campaigns (Eloqua)' as Descr, Campaign_Name, Start_Date, End_Date, Campaign_Type
from [Monthly_Metrics_Campaign_List]
where [Vendor] = 'Eloqua'
  and convert(varchar(7), [Start_Date], 120) = @ReportMonth
  and [Campaign_Type] = 'ADHOC'
  and [Campaign_Name] is not null
