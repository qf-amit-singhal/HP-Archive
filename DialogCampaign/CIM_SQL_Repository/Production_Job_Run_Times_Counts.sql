/*
Globally change below if switching between production and stage
cim_meta_db

Globally change below for correct client/environment
cim_eahmdr_leads_db
*/

SELECT
   elh.Component_Id
   ,c.name
   ,j.description
   ,jh.actual_process_dttm
   ,jh.Duration_Minutes_Num
  ,elh.job_history_id
  ,j.job_id
  ,pc.PROCESS_CAPABILITY_ID
  ,pc.name
  ,lhrh.lead_generation_cnt
FROM cim_meta_db.dbo.CR_EXECUTION_LIST_HISTORY ELH
JOIN cim_meta_db.dbo.CR_JOB_HISTORY JH
   ON ELH.job_history_id = jh.job_history_id
JOIN cim_meta_db.dbo.CM_COMMUNICATION C
   ON ELH.COMPONENT_ID = C.COMMUNICATION_ID
JOIN cim_meta_db.dbo.CR_JOB J
   ON JH.JOB_ID = J.JOB_ID
JOIN cim_meta_db.dbo.CR_PROCESS_CAPABILITY PC
   ON J.PROCESS_CAPABILITY_ID = PC.PROCESS_CAPABILITY_ID
LEFT JOIN cim_eahmdr_leads_db.dbo.LH_RUN_HISTORY LHRH
   ON JH.RUN_ID = LHRH.RUN_ID
WHERE ELH.COMPONENT_TYPE_CD = 12 ---12 for Communication Type
  --and elh.Component_Id IN ('2000fvq83lts', --EAH_Refill_Reminder_Comm
  --                         '2000fvq839g7' --EAH_Dosage_Reminder
  --                         )
  and jh.actual_process_dttm >= cast(getdate() - 7 as date)
ORDER BY jh.actual_process_dttm desc

