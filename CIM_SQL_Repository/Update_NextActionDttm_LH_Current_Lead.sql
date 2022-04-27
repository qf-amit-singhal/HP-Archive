
select c.communication_id, c.name comm_name, s.step_id, s.name step_name, next_action_dttm, count(1)
from   cim_hmcmdr_leads_db.dbo.lh_current_lead lh
join   cim_meta_db.dbo.cm_step s on lh.step_id = s.step_id
join   cim_meta_stage_db.dbo.cm_communication c on lh.communication_id = c.communication_id
group by c.communication_id, c.name, s.step_id, s.name, next_action_dttm


begin transaction

--update cim_hmcmdr_leads_db.dbo.lh_current_lead
--set next_action_dttm = '01/16/2017'
select TOP 100 * from cim_hmcmdr_leads_db.dbo.lh_current_lead
where  communication_id = '2000gnn9r02n' --HMC PATRANS2016 Email Stream
  and  step_id = '2000gnn9rcgl' --Honda EM Touch 3
  
--rollback
--commit