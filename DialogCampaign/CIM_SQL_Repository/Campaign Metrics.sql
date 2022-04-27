/*=====================================================================================
Active Communications:  These are recurring campaigns, or multi-step campaigns that are active
 - Limiting to comms that have resulted in leads (just to clear out old or test comms from TEVA)
 - End Date is NULL (recurring campaign with no known end date)
   OR
   End Date is >= 1st of Month being evaluated for Metrics
   
New Active Comms: These are recurring campaigns, or multi-step campaigns that are active and new as of the month being evaluated for metrics
 - Limiting to comms that have resulted in leads (just to clear out old or test comms from TEVA)
 - End Date is NULL (recurring campaign with no known end date)
   OR
   End Date is >= 1st of Month being evaluated for Metrics
 - Start Date is within the Month being evaluated for Metrics
 
New Adhoc Comms: These are one-time, one "step" campaigns that happened in the month being evaluated for metrics
 - Limiting to comms that have resulted in leads (just to clear out old or test comms from TEVA)
 - Start Date is within the Month being evaluated for Metrics
 - Start Date = End Date
=====================================================================================*/
DECLARE @MonthlyMetricStartDate DATE,
        @MonthlyMetricEndDate DATE

--SET @MonthlyMetricStartDate = '02/01/2016'
--SET @MonthlyMetricEndDate = '02/29/2016'
SET @MonthlyMetricStartDate = CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) as DATE) -- FirtDayPreviousMonth
SET @MonthlyMetricEndDate = CAST(DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)) as DATE) --LastDayPreviousMonth 

PRINT 'Monthly Metric Start Date: ' + convert(varchar(10), @MonthlyMetricStartDate, 101)
PRINT 'Monthly Metric End Date  : ' + convert(varchar(10), @MonthlyMetricEndDate, 101)

IF OBJECT_ID ('TEMPDB..#CommunicationsWithLeads') IS NOT NULL DROP TABLE #CommunicationsWithLeads
select mds.name client, c.communication_id, c.name comm_nm, 
       c.actual_communication_start_dt as start_dt, c.actual_communication_end_dt as end_dt
into   #CommunicationsWithLeads
from   cim_meta_db.dbo.cm_communication c
join   cim_meta_db.dbo.md_schema mds on c.schema_id = mds.schema_id
where  exists ( --select 1
                --from   cim_teva_leads_db.dbo.lh_lead_key_history ch_teva
                --where  ch_teva.communication_id = c.communication_id
                --  and  ch_teva.communication_id <> '1000f0ml8cfz'  --HCP Lead Injector
                --union all                 
                select 1
                from   cim_eahmdr_leads_db.dbo.LH_LEAD_KEY_HISTORY ch_eahmdr
                where  ch_eahmdr.communication_id = c.communication_id
                  and  ch_eahmdr.communication_id <> '1000fx90pkm9' --Pre-Deployment Functionality Test
                union all
                select 1
                from   cim_regmdr_leads_db.dbo.lh_lead_key_history ch_regmdr
                where  ch_regmdr.communication_id = c.communication_id
                union all
                select 1
                from   cim_hapmdr_leads_db.dbo.lh_lead_key_history ch_hapmdr
                where  ch_hapmdr.communication_id = c.communication_id
                union all
                select 1
                from   cim_hmcmdr_leads_db.dbo.lh_lead_key_history ch_hmcmdr
                where  ch_hmcmdr.communication_id = c.communication_id
                union all
                select 1
                from   cim_sfcumdr_leads_db.dbo.lh_lead_key_history ch_sfcumdr
                where  ch_sfcumdr.communication_id = c.communication_id
               )


IF OBJECT_ID ('TEMPDB..#ActiveComms') IS NOT NULL DROP TABLE #ActiveComms
select mds.name client, c.communication_id, c.name comm_nm, 
       c.actual_communication_start_dt as start_dt, c.actual_communication_end_dt as end_dt
into   #ActiveComms
from   cim_meta_db.dbo.cm_communication c
join   #CommunicationsWithLeads t on t.communication_id = c.communication_id
join   cim_meta_db.dbo.md_schema mds on c.schema_id = mds.schema_id
where  (c.Actual_Communication_End_Dt is null and Actual_Communication_Start_Dt is not null)
   or  (Actual_Communication_End_Dt >= @MonthlyMetricStartDate 
        /*Added This Line to make sure Active excludes Adhocs*/
        and Actual_Communication_Start_Dt <> Actual_Communication_End_Dt
        ) 


IF OBJECT_ID ('TEMPDB..#NewActiveComms') IS NOT NULL DROP TABLE #NewActiveComms
select mds.name client, c.communication_id, c.name comm_nm, 
       c.actual_communication_start_dt as start_dt, c.actual_communication_end_dt as end_dt
into   #NewActiveComms
from   cim_meta_db.dbo.cm_communication c
join   #CommunicationsWithLeads t on t.communication_id = c.communication_id
join   cim_meta_db.dbo.md_schema mds on c.schema_id = mds.schema_id
where  (c.Actual_Communication_Start_Dt between @MonthlyMetricStartDate and @MonthlyMetricEndDate)
  and  (isNULL(Actual_Communication_Start_Dt,'01/01/1900') <> isNULL(c.Actual_Communication_End_Dt,'01/01/1900'))

IF OBJECT_ID ('TEMPDB..#NewAdhocComms') IS NOT NULL DROP TABLE #NewAdhocComms
select mds.name client, c.communication_id, c.name comm_nm, 
       c.actual_communication_start_dt as start_dt, c.actual_communication_end_dt as end_dt
into   #NewAdhocComms
from   cim_meta_db.dbo.cm_communication c
join   #CommunicationsWithLeads t on t.communication_id = c.communication_id
join   cim_meta_db.dbo.md_schema mds on c.schema_id = mds.schema_id
where  (c.Actual_Communication_Start_Dt between @MonthlyMetricStartDate and @MonthlyMetricEndDate)
  and  (Actual_Communication_Start_Dt = c.Actual_Communication_End_Dt)


/*=====================================================================================
Monthly Metrics
=====================================================================================*/
select 'Total Active Communications' Description, count(1) Total
from   #ActiveComms
union all
select 'Total New Active Communications' Description, count(1) Total
from   #NewActiveComms
union all
select 'Total New Ad-hoc Communications' Description, count(1) Total
from   #NewAdhocComms


/*=====================================================================================
Communications used for Metrics by Client
=====================================================================================*/
select * from #CommunicationsWithLeads order by client, comm_nm
select * from #ActiveComms order by client, comm_nm
select * from #NewActiveComms order by client, comm_nm
select * from #NewAdhocComms order by client, comm_nm


