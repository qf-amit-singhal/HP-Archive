use cim_meta_stage_Db
go

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
FROM CR_EXECUTION_LIST_HISTORY ELH
JOIN CR_JOB_HISTORY JH
   ON ELH.job_history_id = jh.job_history_id
JOIN CM_COMMUNICATION C
   ON ELH.COMPONENT_ID = C.COMMUNICATION_ID
JOIN CR_JOB J
   ON JH.JOB_ID = J.JOB_ID
JOIN CR_PROCESS_CAPABILITY PC
   ON J.PROCESS_CAPABILITY_ID = PC.PROCESS_CAPABILITY_ID
WHERE ELH.COMPONENT_TYPE_CD = 12 ---12 for Communication Type
--and c.communication_id = '2000fvq839gc'
--and elh.Component_Id = '2000fvq839g7'
and elh.Component_Id = '2000fvq83lts'
ORDER BY jh.actual_process_dttm desc

SELECT
   elh.Component_Id
   ,c.name
   ,j.description
   ,avg(jh.Duration_Minutes_Num)
FROM CR_EXECUTION_LIST_HISTORY ELH
JOIN CR_JOB_HISTORY JH
   ON ELH.job_history_id = jh.job_history_id
JOIN CM_COMMUNICATION C
   ON ELH.COMPONENT_ID = C.COMMUNICATION_ID
JOIN CR_JOB J
   ON JH.JOB_ID = J.JOB_ID
JOIN CR_PROCESS_CAPABILITY PC
   ON J.PROCESS_CAPABILITY_ID = PC.PROCESS_CAPABILITY_ID
WHERE ELH.COMPONENT_TYPE_CD = 12 ---12 for Communication Type
--and c.communication_id = '2000fvq839gc'
and elh.Component_Id in ('2000fvq839g7', '2000fvq83lts')
group by elh.Component_Id
   ,c.name
   ,j.description


