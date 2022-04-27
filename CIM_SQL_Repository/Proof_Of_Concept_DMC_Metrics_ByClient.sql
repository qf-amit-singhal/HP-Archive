select convert(varchar(10), getdate(),101) Run_date, count(1) Emails_Sent
from emailCampaigns_adhoc.dbo.RawDataExport_DMC_Metrics 
where cast(sentToMTA_Timestamp as date) >= '07/22/2016'
  and group_category_name not like '%TEST%'
--1214471

/*DMC Monthly Metrics Summary by Client*/
select case when group_category_name like 'regeneron%' or group_category_name = 'NON_PHYSICIAN_STAFF' then 'Regeneron'
            when group_category_name like 'RGN%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
            when group_category_name like 'FORD%' then 'Ford'
            else group_category_name
       end [Client]
     , convert(varchar(10),min(cast(sentToMTA_Timestamp as date)),112) [Min Send Date]
     , convert(varchar(10),max(cast(sentToMTA_Timestamp as date)),112) [Max Send Date]
     , count(1) Total
     , count(case when cast(sentToMTA_Timestamp as date) between CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) as DATE) and CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)) as DATE) then user_Id else null end ) [Total_Prev1_Mo]
     , count(case when cast(sentToMTA_Timestamp as date) between CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0) as DATE) and CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)) as DATE) then user_Id else null end ) Total_Prev2_Mo
     , count(case when cast(sentToMTA_Timestamp as date) between CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0) as DATE) and CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, -1, getdate()) - 3, 0)) as DATE) then user_Id else null end ) Total_Prev3_Mo
     , count(case when cast(sentToMTA_Timestamp as date) between CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0) as DATE) and CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, -1, getdate()) - 4, 0)) as DATE) then user_Id else null end ) Total_Prev4_Mo
     , count(case when cast(sentToMTA_Timestamp as date) between CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0) as DATE) and CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, -1, getdate()) - 5, 0)) as DATE) then user_Id else null end ) Total_Prev5_Mo
     , count(case when cast(sentToMTA_Timestamp as date) between CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0) as DATE) and CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, -1, getdate()) - 6, 0)) as DATE) then user_Id else null end ) Total_Prev6_Mo
     , count(case when cast(sentToMTA_Timestamp as date) between CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0) as DATE) and CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, -1, getdate()) - 7, 0)) as DATE) then user_Id else null end ) Total_Prev7_Mo
     , count(case when cast(sentToMTA_Timestamp as date) between CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0) as DATE) and CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, -1, getdate()) - 8, 0)) as DATE) then user_Id else null end ) Total_Prev8_Mo
     , count(case when cast(sentToMTA_Timestamp as date) between CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0) as DATE) and CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, -1, getdate()) - 9, 0)) as DATE) then user_Id else null end ) Total_Prev9_Mo
     , count(case when cast(sentToMTA_Timestamp as date) between CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0) as DATE) and CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, -1, getdate()) - 10, 0)) as DATE) then user_Id else null end ) Total_Prev10_Mo
     , count(case when cast(sentToMTA_Timestamp as date) between CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 12, 0) as DATE) and CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, -1, getdate()) - 11, 0)) as DATE) then user_Id else null end ) Total_Prev11_Mo
     , count(case when cast(sentToMTA_Timestamp as date) between CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 13, 0) as DATE) and CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, -1, getdate()) - 12, 0)) as DATE) then user_Id else null end ) Total_Prev12_Mo
from  emailCampaigns_adhoc.dbo.RawDataExport_DMC_Metrics
where group_category_name not like '%TEST%'
group by case when group_category_name like 'regeneron%' or group_category_name = 'NON_PHYSICIAN_STAFF' then 'Regeneron'
            when group_category_name like 'RGN%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
            when group_category_name like 'FORD%' then 'Ford'
            else group_category_name
       end
order by 1

