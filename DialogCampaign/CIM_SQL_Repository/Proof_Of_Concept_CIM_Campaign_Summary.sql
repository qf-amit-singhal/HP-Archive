select 'CIM' [Application]
      , t.client [Client Name]
      , count(case when Actual_Communication_End_Dt is null then t.communication_id end) [Total Active Recurring]
      , count(case when Actual_Communication_Start_Dt = Actual_Communication_End_Dt then t.communication_id end) [Total Adhoc]
      , count(case when Actual_Communication_Start_Dt <> Actual_Communication_End_Dt then t.communication_id end) [Total Deactivated Campaigns]
      , count(case when Actual_Communication_Start_Dt >= CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) as DATE) then t.communication_id end) [Total New Last Mo]
from cim_views_db.dbo.cim_communications_with_leads_vw t
group by t.client
order by t.client
