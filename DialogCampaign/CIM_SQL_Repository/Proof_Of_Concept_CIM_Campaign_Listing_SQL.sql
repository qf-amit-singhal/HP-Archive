use cim_views_db
go 

select 'CIM' [Application]
      , t.client [Client Name]
      , t.comm_nm [Campaign Name]
      , t.Actual_Communication_Start_Dt [Start Date]
      , t.Actual_Communication_End_Dt [End Date]
      , t.comm_type_descr [Type]
      , cch.Channel [Channel]
      , case when Actual_Communication_Start_Dt = Actual_Communication_End_Dt then 'Ad-hoc'
             when Actual_Communication_End_Dt is null then 'Recurring-Active'
             when Actual_Communication_Start_Dt < Actual_Communication_End_Dt then 'Recurring-Inactive'
        end [Adhoc/Recurring]
      --, case when Actual_Communication_Start_Dt >= CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) as DATE) then 'Y' else 'N' end New_Last_Month    
from cim_communications_with_leads_vw t
left join ( select distinct a.communication_id, case when Channel_Cnt = 1 then cm_channel_class else 'Multi-Channel' end Channel
            from   cim_views_db.dbo.cim_comm_channel_class_vw a
            left join ( select communication_id, count(distinct cm_channel_class) Channel_Cnt
                        from   cim_views_db.dbo.cim_comm_channel_class_vw
                        group by communication_id
                       ) b on a.communication_id = b.communication_id
           ) cch on t.communication_id = cch.communication_id
order by t.client, t.comm_nm




use cim_views_db
go 

select 'CIM' [Application]
      , t.client [Client Name]
      , count(case when Actual_Communication_End_Dt is null then t.communication_id end) [Total Active Recurring]
      , count(case when Actual_Communication_Start_Dt = Actual_Communication_End_Dt then t.communication_id end) [Total Adhoc]
      , count(case when Actual_Communication_Start_Dt <> Actual_Communication_End_Dt then t.communication_id end) [Total Deactivated Campaigns]
      , count(case when Actual_Communication_Start_Dt >= CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) as DATE) then t.communication_id end) [Total New Last Mo]
from cim_communications_with_leads_vw t
group by t.client
order by t.client
