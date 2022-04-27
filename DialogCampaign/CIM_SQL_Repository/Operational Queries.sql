
select 'Regeneron' Client
     , comm.communication_id
     , comm.name comm_nm
     , count(1) Total
     , count(distinct reg_cont_id) Unique_Contacts
     , sum(case when cast(lhcl.step_dttm as date) = cast(getdate() as date) then 1 else 0 end) Total_Stepped_Today
     , sum(case when cast(lhcl.selection_dttm as date) = cast(getdate() as date) then 1 else 0 end) Total_Selected_Today
from   cim_regmdr_leads_db.dbo.lh_current_lead lhcl
join   cim_meta_db.dbo.cm_communication comm on lhcl.communication_id = comm.communication_id
group by comm.communication_id,  comm.name
order by comm.communication_id,  comm.name
--2703	2632


select comm_nm
     , step_nm
     , reg_cadence_step_no
     , reg_cadence_step_type
     --, lh.step_dttm
     , cast(lh.step_dttm as date) step_dt
     , count(1) Total
from   cim_regmdr_views_db.dbo.CIM_LH_COLLATERAL_HIST lh
where  step_dt >= cast(getdate() - 30 as date)
  --and  communication_id = '2000fx5fnn6l'
group by comm_nm
     , step_nm
     , reg_cadence_step_no
     , reg_cadence_step_type
     --, lh.step_dttm
     , cast(lh.step_dttm as date)
order by comm_nm, cast(lh.step_dttm as date) desc, reg_cadence_step_no, reg_cadence_step_type, step_nm
GO


select 'Elanco' Client
     , comm.communication_id
     , comm.name comm_nm
     , count(1) Total
     , count(distinct eah_cont_id) Unique_Contacts
     , sum(case when cast(lhcl.step_dttm as date) = cast(getdate() as date) then 1 else 0 end) Total_Stepped_Today
     , sum(case when cast(lhcl.selection_dttm as date) = cast(getdate() as date) then 1 else 0 end) Total_Selected_Today
     , min(lhcl.selection_dttm) min_selection_dttm
     , max(lhcl.selection_dttm) max_selection_dttm
     , min(lhcl.step_dttm) min_step_date
     , max(lhcl.step_dttm) max_step_date
from   cim_eahmdr_leads_db.dbo.lh_current_lead lhcl
join   cim_meta_db.dbo.cm_communication comm on lhcl.communication_id = comm.communication_id
group by comm.communication_id,  comm.name
order by comm.communication_id,  comm.name
