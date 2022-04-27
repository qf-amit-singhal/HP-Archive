select main.*
from (select  1 module_no, 'Communications' as module_nm, s.name schema_nm, dev.communication_id as obj_id,
              prod.name as obj_nm, prod.name as comm_nm, prod.update_dttm as prod_update_dttm,
              dev.name as dev_nm, dev.update_dttm as dev_update_dttm,
              (case when dev.update_dttm=prod.update_dttm then 'Same'when dev.update_dttm>prod.update_dttm then 'Dev Newer'
              when dev.update_dttm<prod.update_dttm then 'Prod Newer' else '?' end) as dttm_match_desc
      from cim_meta_db.dbo.cm_communication prod
      join cim_Meta_stage_db.dbo.cm_communication dev
        on prod.communication_id=dev.communication_id
      join cim_meta_db.dbo.MD_SCHEMA s 
        on prod.schema_id = s.Schema_id
      UNION
      select  2 module_no, 'Comm Plans' as module_nm,s.name schema_nm, dev.Comm_Plan_Id as obj_id,
              prod.name as obj_nm, comm.name as comm_nm, prod.update_dttm as prod_update_dttm,
              dev.name as dev_nm, dev.update_dttm as dev_update_dttm,
              (case when dev.update_dttm=prod.update_dttm then 'Same'when dev.update_dttm>prod.update_dttm then 'Dev Newer'
              when dev.update_dttm<prod.update_dttm then 'Prod Newer' else '?' end) as dttm_match_desc
      from cim_meta_db.dbo.cm_comm_plan prod
      join cim_Meta_stage_db.dbo.cm_comm_Plan dev
        on prod.comm_plan_id=dev.comm_plan_id 
      join cim_meta_stage_db.dbo.cm_communication_comm_plan ccp
        on dev.comm_plan_id=ccp.comm_plan_id
      join cim_meta_stage_db.dbo.cm_communication comm
        on ccp.communication_Id=comm.communication_id
      join cim_meta_db.dbo.MD_SCHEMA s on comm.schema_id = s.Schema_id
      UNION
      select  3 module_no, 'Segment Plans' as module_nm, s.name schema_nm, dev.segment_plan_id as obj_id,
              prod.name as obj_nm, comm.name as comm_nm, prod.update_dttm as prod_update_dttm,
              dev.name as dev_nm, dev.update_dttm as dev_update_dttm,
              (case when dev.update_dttm=prod.update_dttm then 'Same'when dev.update_dttm>prod.update_dttm then 'Dev Newer'
              when dev.update_dttm<prod.update_dttm then 'Prod Newer' else '?' end) as dttm_match_desc
      from cim_meta_db.dbo.sm_segment_plan prod
      join cim_Meta_stage_db.dbo.sm_segment_Plan dev
        on prod.segment_plan_id=dev.segment_plan_id 
      join cim_meta_stage_db.dbo.cm_communication comm 
        on dev.segment_plan_id=comm.segment_plan_id
      join cim_meta_db.dbo.MD_SCHEMA_ELEMENT se 
        on prod.schema_element_id = se.schema_element_id
      join cim_meta_db.dbo.MD_SCHEMA s 
        on se.schema_id = s.schema_id
      UNION 
      select  4 module_no, 'Segments' as module_nm, s.name schema_nm, dev.segment_id as obj_id,
              prod.name as obj_nm, comm.name as comm_nm, prod.update_dttm as prod_update_dttm,
              dev.name as dev_nm, dev.update_dttm as dev_update_dttm,
              (case when dev.update_dttm=prod.update_dttm then 'Same'when dev.update_dttm>prod.update_dttm then 'Dev Newer'
              when dev.update_dttm<prod.update_dttm then 'Prod Newer' else '?' end) as dttm_match_desc
      from cim_meta_db.dbo.sm_segment prod
      join cim_Meta_stage_db.dbo.sm_segment dev
        on prod.segment_id=dev.segment_id 
      join cim_meta_stage_db.dbo.sm_logical_segment log_seg 
        on dev.segment_id=log_seg.segment_id
      join cim_meta_stage_db.dbo.cm_communication comm 
        on log_seg.segment_plan_id=comm.segment_plan_id
      join cim_meta_db.dbo.MD_SCHEMA s 
        on comm.schema_id = s.schema_id
      UNION
      select  5 module_no, 'Steps' as module_nm,s.name schema_nm, dev.step_id as obj_id,
              prod.name as obj_nm, comm.name as comm_nm, prod.update_dttm as prod_update_dttm,
              dev.name as dev_nm, dev.update_dttm as dev_update_dttm,
              (case when dev.update_dttm=prod.update_dttm then 'Same'when dev.update_dttm>prod.update_dttm then 'Dev Newer'
              when dev.update_dttm<prod.update_dttm then 'Prod Newer' else '?' end) as dttm_match_desc
      from cim_meta_db.dbo.cm_step prod
      join cim_Meta_stage_db.dbo.cm_step dev
        on prod.step_id=dev.step_id 
      join cim_meta_stage_db.dbo.cm_comm_plan_step ccps 
        on dev.step_id=ccps.step_id
      join cim_meta_stage_db.dbo.CM_COMMUNICATION_COMM_PLAN ccp 
        on ccp.comm_plan_id=ccps.comm_plan_id
      join cim_meta_stage_db.dbo.cm_communication comm 
        on ccp.communication_id=comm.communication_id
      join cim_meta_db.dbo.MD_SCHEMA s on comm.schema_id = s.schema_id
      UNION
      select  6 module_no, 'Output Templates' as module_nm, s.name schema_nm, dev.presentation_template_id as obj_id,
              prod.name as obj_nm, comm.name as comm_nm, prod.update_dttm as prod_update_dttm,
              dev.name as dev_nm, dev.update_dttm as dev_update_dttm,
              (case when dev.update_dttm=prod.update_dttm then 'Same'when dev.update_dttm>prod.update_dttm then 'Dev Newer'
              when dev.update_dttm<prod.update_dttm then 'Prod Newer' else '?' end) as dttm_match_desc
      from cim_meta_db.dbo.OM_PRESENTATION_TEMPLATE prod
      join cim_Meta_stage_db.dbo.om_presentation_template dev
        on prod.Presentation_Template_Id=dev.Presentation_Template_Id
      join cim_meta_stage_db.dbo.cm_comm_package_presentation ccps 
        on dev.presentation_template_id=ccps.presentation_template_id
      join cim_meta_stage_db.dbo.CM_COMMUNICATION_COMM_PLAN ccp 
        on ccp.comm_plan_id=ccps.comm_plan_id
      join cim_meta_stage_db.dbo.cm_communication comm 
        on ccp.communication_id=comm.communication_id
      join cim_meta_db.dbo.MD_SCHEMA s 
        on comm.schema_id = s.schema_id
      UNION
      select  7 module_no, 'Output Formats' as module_nm,s.name schema_nm, dev.extract_format_id as obj_id,
              prod.name as obj_nm, comm.name as comm_nm, prod.update_dttm as prod_update_dttm,
              dev.name as dev_nm, dev.update_dttm as dev_update_dttm,
              (case when dev.update_dttm=prod.update_dttm then 'Same'when dev.update_dttm>prod.update_dttm then 'Dev Newer'
      when dev.update_dttm<prod.update_dttm then 'Prod Newer' else '?' end) as dttm_match_desc
      from cim_meta_db.dbo.OM_EXTRACT_FORMAT prod
      join cim_Meta_stage_db.dbo.OM_EXTRACT_FORMAT dev
        on prod.Extract_Format_Id=dev.extract_format_id
      join cim_meta_stage_db.dbo.OM_PRESENTATION_TEMPLATE templ
        on dev.Extract_Format_Id=templ.Extract_Format_Id
      join cim_meta_stage_db.dbo.cm_comm_package_presentation ccps 
        on templ.presentation_template_id=ccps.presentation_template_id
      join cim_meta_stage_db.dbo.CM_COMMUNICATION_COMM_PLAN ccp 
        on ccp.comm_plan_id=ccps.comm_plan_id
      join cim_meta_stage_db.dbo.cm_communication comm 
        on ccp.communication_id=comm.communication_id
      join cim_meta_db.dbo.MD_SCHEMA s 
        on comm.schema_id = s.schema_id
      UNION
      select 8 module_no, 'Collateral' as module_nm, s.name schema_nm, dev.collateral_id as obj_id,
      prod.name as obj_nm, comm.name as comm_nm, prod.update_dttm as prod_update_dttm,
      dev.name as dev_nm, dev.update_dttm as dev_update_dttm,
      (case when dev.update_dttm=prod.update_dttm then 'Same'when dev.update_dttm>prod.update_dttm then 'Dev Newer'
      when dev.update_dttm<prod.update_dttm then 'Prod Newer' else '?' end) as dttm_match_desc
      from cim_meta_db.dbo.cm_collateral prod
      join cim_Meta_stage_db.dbo.cm_collateral dev
        on prod.collateral_Id=dev.collateral_id
      join cim_meta_stage_db.dbo.cm_comm_package_collateral ccps 
        on dev.collateral_id=ccps.collateral_id
      join cim_meta_stage_db.dbo.CM_COMMUNICATION_COMM_PLAN ccp 
        on ccp.comm_plan_id=ccps.comm_plan_id
      join cim_meta_stage_db.dbo.cm_communication comm 
        on ccp.communication_id=comm.communication_id
      join cim_meta_db.dbo.MD_SCHEMA s 
        on comm.schema_id = s.schema_id
      UNION
      select  9 module_no, 'Response Segments' as module_nm,s.name schema_nm, dev.segment_id as obj_id,
              prod.name as obj_nm, comm.name as comm_nm, prod.update_dttm as prod_update_dttm,
              dev.name as dev_nm, dev.update_dttm as dev_update_dttm,
              (case when dev.update_dttm=prod.update_dttm then 'Same'when dev.update_dttm>prod.update_dttm then 'Dev Newer'
              when dev.update_dttm<prod.update_dttm then 'Prod Newer' else '?' end) as dttm_match_desc
      from cim_meta_db.dbo.SM_SEGMENT prod
      join cim_Meta_stage_db.dbo.SM_SEGMENT dev
        on prod.Segment_Id=dev.Segment_id
      join cim_meta_stage_db.dbo.cm_response resp 
        on dev.segment_id=resp.segment_id
      join cim_meta_stage_db.dbo.CM_STEP_RESPONSE step_resp
        on resp.response_id=step_resp.response_id
      join cim_meta_stage_db.dbo.CM_COMMUNICATION_COMM_PLAN ccp 
        on ccp.comm_plan_id=step_resp.comm_plan_id
      join cim_meta_stage_db.dbo.cm_communication comm 
        on ccp.communication_id=comm.communication_id
      join cim_meta_db.dbo.MD_SCHEMA s 
        on comm.schema_id = s.schema_id
      ) main
where main.dttm_match_desc<>'Same'
order by main.schema_nm, main.module_no, main.dttm_match_desc
