begin transaction
delete from cim_regmdr_leads_db.dbo.lh_current_lead where communication_id='2000fssvbhjg';
delete from cim_regmdr_leads_db.dbo.lh_realized_lead where communication_id='2000fssvbhjg';
delete from cim_regmdr_leads_db.dbo.lh_lead_key_history where communication_id='2000fssvbhjg';
delete from cim_regmdr_leads_db.dbo.lh_collateral_history where communication_id='2000fssvbhjg';
delete from cim_regmdr_leads_db.dbo.lh_lead_event_history where communication_id='2000fssvbhjg';
delete from cim_regmdr_leads_db.dbo.lh_delivery_history where communication_id='2000fssvbhjg';
delete from cim_regmdr_leads_db.dbo.lh_channel_response where communication_id='2000fssvbhjg';
delete from cim_regmdr_leads_db.dbo.lh_channel_history where communication_id='2000fssvbhjg';
delete from cim_regmdr_leads_db.dbo.LH_CONTACT_HISTORY where communication_id='2000fssvbhjg';
delete from cim_regmdr_leads_db.dbo.LH_lead_status_HISTORY where communication_id='2000fssvbhjg';

--rollback
--commit


select step_nm
     , reg_cadence_step_no
     , reg_cadence_step_type
     , lh.step_dttm
     , lh.segment_name
     , count(1) Total
from   cim_regmdr_views_db.dbo.CIM_LH_COLLATERAL_HIST lh
where communication_id = '2000fssvbhjg'
group by step_nm
     , reg_cadence_step_no
     , reg_cadence_step_type
     , lh.step_dttm
     , lh.segment_name
order by lh.step_dttm, reg_cadence_step_no, reg_cadence_step_type, step_nm
GO
