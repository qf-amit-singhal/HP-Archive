use cim_meta_db
go

select j.description, j.processing_engine_id, jh.* 
from   cr_job_history jh
join   cr_job j on jh.job_id = j.job_id
where  run_status_cd = '1'

select *
from   dbo.CR_COMPONENT_LOCK

select * 
from   dbo.CR_COMPONENT_LOCK_QUEUE

select *
from   dbo.MD_DOMAIN
where  domain_name = 'RUN_STATUS_CD'

begin transaction
update cr_job_history
set run_status_cd = '3'
where  run_status_cd = '1'

delete from dbo.CR_COMPONENT_LOCK
delete from dbo.CR_COMPONENT_LOCK_QUEUE

--rollback
--commit

