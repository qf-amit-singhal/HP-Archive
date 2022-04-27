

select distinct comm.communication_id, comm.name comm_name, 
       step.step_id, step.name step_name, exstep.reg_cadence_step_type, exstep.reg_cadence_step_no, 
       collat.collateral_id, collat.name collateral_name, ec.reg_internal_Code, ec.reg_external_code
       ,seg.name segment_name
from cim_meta_stage_db.dbo.cm_communication comm 
left join cim_meta_stage_db.dbo.ex_communication excomm on comm.communication_id = excomm.communication_id
join cim_meta_stage_db.dbo.cm_comm_package comm_pkg on comm.Communication_Id=comm_pkg.Communication_Id
join cim_meta_stage_db.dbo.cm_comm_package_collateral pkg_collat on comm_pkg.package_id=pkg_collat.package_id
join cim_meta_stage_db.dbo.cm_step step on comm_pkg.step_id = step.step_id
join cim_meta_stage_db.dbo.ex_step exstep on step.step_id = exstep.step_id
join cim_meta_stage_db.dbo.CM_COLLATERAL collat on pkg_collat.collateral_id=collat.collateral_id
join cim_meta_stage_db.dbo.EX_COLLATERAL ec on collat.Collateral_Id = ec.Collateral_Id
join cim_meta_stage_db.dbo.sm_logical_segment log_seg on comm_pkg.Logical_Segment_Id=log_seg.Logical_Segment_Id
join cim_meta_stage_db.dbo.sm_segment seg on log_seg.Segment_Id=seg.Segment_Id
where  comm.Communication_Id IN ('2000f9x0vqr8')
  and  exstep.reg_cadence_step_type = 'CRM_MAIN'
  --and  exstep.reg_cadence_step_no = 1
order by  exstep.reg_cadence_step_no, ec.reg_internal_Code