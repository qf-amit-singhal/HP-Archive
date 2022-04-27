/*Change DB Names to View Results for Different Client*/
select c.communication_id, c.name comm_name, s.step_id, s.name step_name, next_action_dttm, timeout_action, timeout_step_to, count(1) Total
from   cim_hmcmdr_leads_db.dbo.lh_current_lead lh
join   cim_meta_db.dbo.cm_step s on lh.step_id = s.step_id
join   cim_meta_stage_db.dbo.cm_communication c on lh.communication_id = c.communication_id  
left join (select distinct communication_id, step_id, timeout_action, timeout_step_to
           from   cim_hmcmdr_views_db.dbo.CIM_STEP_RESP_AUDIT
          ) sa on lh.communication_id = sa.communication_id and lh.step_id = sa.step_id
group by c.communication_id, c.name, s.step_id, s.name, next_action_dttm, timeout_action, timeout_step_to
order by c.communication_id, c.name, s.step_id, s.name, next_action_dttm, timeout_action, timeout_step_to

/*View Responses that were hit by comm, step, response, date*/
select comm.name, comm.communication_id, step.name as step_nm, resp.name as resp_nm, resps.response_dttm, count (*) amt
from cim_hmcmdr_leads_db.dbo.LH_CHANNEL_RESPONSE resps
join cim_meta_db.dbo.cm_communication comm
on comm.communication_id=resps.communication_id
join cim_meta_db.dbo.CM_RESPONSE resp
on resps.response_id=resp.Response_Id
join cim_meta_db.dbo.cm_step step
on resps.step_id=step.step_id
group by comm.name, comm.communication_id,step.name, resp.name, resps.response_dttm
order by resps.response_dttm desc, comm.name



