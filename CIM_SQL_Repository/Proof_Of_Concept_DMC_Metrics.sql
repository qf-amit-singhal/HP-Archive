use emailCampaigns_adhoc
go 

--if object_id('RawDataExport_DMC_Metrics') is not null drop table RawDataExport_DMC_Metrics
--go

--create table RawDataExport_DMC_Metrics (
--   cast(sentToMTA_Timestamp as date)         varchar(50)
--  ,group_Id                    varchar(50)
--  ,group_Name                  varchar(50)
--  ,group_Email                 varchar(255)
--  ,group_Category_Name         varchar(50)
--  ,message_Id                  varchar(50)
--  ,message_Name                varchar(255)
--  ,message_Category_Name       varchar(50)
--  --,message_Subject_Unresolved  varchar(800)
--  ,message_Type                varchar(50)
--  ,record_Timestamp            varchar(50)
--  ,record_Type                 varchar(50)
--  ,record_cast(sentToMTA_Timestamp as date)  varchar(50)
--  ,user_Id                     varchar(50)
--  ,user_Email                  varchar(255)
--  ,user_AlternateEmail         varchar(255)                            
--)


--select min(cast([sentToMTA Timestamp] as date)), max(cast([sentToMTA Timestamp] as date)) from dbo.RawDataExportDMCMetricsAllClients_Jan2016_2017_01_04_19_32_37
--select min(cast([sentToMTA Timestamp] as date)), max(cast([sentToMTA Timestamp] as date)) from dbo.RawDataExportDMCMetricsAllClients_Feb2016_2017_01_04_21_17_02
--select min(cast([sentToMTA Timestamp] as date)), max(cast([sentToMTA Timestamp] as date)) from dbo.RawDataExportDMCMetricsAllClients_Mar2016_2017_01_05_18_32_08
--select min(cast([sentToMTA Timestamp] as date)), max(cast([sentToMTA Timestamp] as date)) from dbo.RawDataExportDMCMetricsAllClients_Apr2016_2017_01_05_18_41_41
--select min(cast([sentToMTA Timestamp] as date)), max(cast([sentToMTA Timestamp] as date)) from dbo.RawDataExportDMCMetricsAllClients_May2016_2017_01_05_18_47_29
--select min(cast([sentToMTA Timestamp] as date)), max(cast([sentToMTA Timestamp] as date)) from dbo.RawDataExportDMCMetricsAllClients_Jun2016_2017_01_05_19_01_07
--select min(cast([sentToMTA Timestamp] as date)), max(cast([sentToMTA Timestamp] as date)) from dbo.RawDataExportDMCMetricsAllClients_Jul2016_2017_01_04_19_41_19
--select min(cast([sentToMTA Timestamp] as date)), max(cast([sentToMTA Timestamp] as date)) from dbo.RawDataExportDMCMetricsAllClients_Aug2016_2017_01_05_19_21_25
--select min(cast([sentToMTA Timestamp] as date)), max(cast([sentToMTA Timestamp] as date)) from dbo.RawDataExportDMCMetricsAllClients_Sep2016_2017_01_05_19_33_37
--select min(cast([sentToMTA Timestamp] as date)), max(cast([sentToMTA Timestamp] as date)) from dbo.RawDataExportDMCMetricsAllClients_Oct2016_2017_01_05_19_49_05
--select min(cast([sentToMTA Timestamp] as date)), max(cast([sentToMTA Timestamp] as date)) from dbo.RawDataExportDMCMetricsAllClients_Nov2016_2017_01_04_19_47_48
--select min(cast([sentToMTA Timestamp] as date)), max(cast([sentToMTA Timestamp] as date)) from dbo.RawDataExportDMCMetricsAllClients_Dec2016


--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Jan2016_2017_01_04_19_32_37
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Feb2016_2017_01_04_21_17_02
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Mar2016_2017_01_05_18_32_08
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Apr2016_2017_01_05_18_41_41
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_May2016_2017_01_05_18_47_29
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Jun2016_2017_01_05_19_01_07
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Jul2016_2017_01_04_19_41_19
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Aug2016_2017_01_05_19_21_25
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Sep2016_2017_01_05_19_33_37
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Sep2016_2017_01_05_19_33_37
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Oct2016_2017_01_05_19_49_05
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Nov2016_2017_01_04_19_47_48
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Jan2017_2017_02_02_10_35_21
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Feb2017_2017_03_01_09_42_47 
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Mar2017_2017_04_03_13_03_30
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_Apr2017_2017_05_02_14_28_00
--insert into RawDataExport_DMC_Metrics select * from RawDataExport_DMC_Metrics_May2017
--insert into RawDataExport_DMC_Metrics select * from RawDataExportDMCMetricsAllClients_June2017_2017_07_05_13_49_53 
--insert into RawDataExport_DMC_Metrics select * from [dbo].[RawDataExportDMCMetricsAllClients_July2017_2017_08_02_14_10_18]
--insert into RawDataExport_DMC_Metrics select * from [dbo].[RawDataExportDMCMetricsAllClients_Aug2017_2017_09_08_19_38_13]
--insert into RawDataExport_DMC_Metrics select * from [dbo].[RawDataExportDMCMetricsAllClients_Sep2017]
--insert into RawDataExport_DMC_Metrics select * from dbo.RawDataExportDMCMetricsAllClients_PrevMonth_2017_11_01_14_57_04
--insert into RawDataExport_DMC_Metrics select * from dbo.RawDataExportDMCMetricsAllClients_PrevMonth_2017_12_04_17_53_21
--insert into RawDataExport_DMC_Metrics select * from dbo.RawDataExportDMCMetricsAllClients_PrevMonth_2018_01_02_19_16_46
--insert into RawDataExport_DMC_Metrics select * from dbo.RawDataExportDMCMetricsAllClients_PrevMonth_2018_02_01_14_01_28
--insert into RawDataExport_DMC_Metrics select * from dbo.RawDataExportDMCMetricsAllClients_PrevMonth_2018_03_07_20_25_31
--insert into RawDataExport_DMC_Metrics select * from [dbo].[FRITODMCMetricsAllClients_PrevMonth_2018_03_08_13_08_48]
--insert into RawDataExport_DMC_Metrics select * from [dbo].[RawDataExportDMCMetricsAllClients_March_2018_03_30_19_19_57] 
--delete from RawDataExport_DMC_Metrics where group_category_name = 'Test_Group_Category'

select distinct
       group_category_name,
       case when group_category_name like 'regeneron%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
            else group_category_name
       end
from RawDataExport_DMC_Metrics
       

/*DMC Monthly Metrics Summary by Domain*/
select case when group_category_name like 'regeneron%' then 'Regeneron'
            when group_category_name like 'RGN%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
            else group_category_name
       end client
     , RIGHT(group_email, LEN(group_email) - CHARINDEX('@', group_email)) Domain
     , convert(varchar(10),min(cast(sentToMTA_Timestamp as date)),112) Min_Sent_Date
     , convert(varchar(10),max(cast(sentToMTA_Timestamp as date)),112) Max_Sent_Date
     , count(1) Total
     , count(case when cast(sentToMTA_Timestamp as date) between CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) as DATE) and CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)) as DATE) then user_Id else null end ) Total_Prev1_Mo
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
from  RawDataExport_DMC_Metrics
group by case when group_category_name like 'regeneron%' then 'Regeneron'
            when group_category_name like 'RGN%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
            else group_category_name
       end, RIGHT(group_email, LEN(group_email) - CHARINDEX('@', group_email))
order by case when group_category_name like 'regeneron%' then 'Regeneron'
            when group_category_name like 'RGN%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
            else group_category_name
       end, RIGHT(group_email, LEN(group_email) - CHARINDEX('@', group_email));


/*DMC Monthly Metrics Summary by Client*/
select case when group_category_name like 'regeneron%' then 'Regeneron'
            when group_category_name like 'RGN%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
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
from  RawDataExport_DMC_Metrics
where group_category_name not like '%TEST%'
group by case when group_category_name like 'regeneron%' then 'Regeneron'
            when group_category_name like 'RGN%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
            else group_category_name
       end
order by case when group_category_name like 'regeneron%' then 'Regeneron'
            when group_category_name like 'RGN%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
            else group_category_name
       end



/*DMC Campaign Listing*/
select 'DMC' Application
     , case when group_category_name like 'Regeneron%' then 'Regeneron'
            when group_category_name like 'RGN%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
            else group_category_name
       end [Client Name]
     , message_name [Campaign Name]
     , convert(varchar(10),min(cast(sentToMTA_Timestamp as date)),112) [Start Date]
     , case when max(cast(sentToMTA_Timestamp as date)) >= getdate() -7 then null else convert(varchar(10),max(cast(sentToMTA_Timestamp as date)),112) end [End Date]
     , '' as [Type] --message_Category_Name may be able to be used in the future for this
     , 'Email' as [Channel]
     , case when datediff(dd,min(cast(sentToMTA_Timestamp as date)), max(cast(sentToMTA_Timestamp as date))) <= 5 then 'Ad-hoc' else 'Recurring' end [Adhoc/Recurring]     
     , count(1) Total_Sends
from  RawDataExport_DMC_Metrics
where group_category_name <> 'Test_Group_Category'
group by case when group_category_name like 'regeneron%' then 'Regeneron'
            when group_category_name like 'RGN%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
            else group_category_name
       end
         , group_category_name, message_name 
order by case when group_category_name like 'regeneron%' then 'Regeneron'
            when group_category_name like 'RGN%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
            else group_category_name
       end, group_category_name, message_name;
       
       