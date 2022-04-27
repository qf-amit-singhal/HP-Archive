select (case when oef.local_copy_ind=1 then 'Local' else 'Global' end) as local_ind , mdt.name table_nm, mdc.name col_nm, oef.name Extract_Format_Nm, oef.extract_format_id,
cc.name as communication_nm, cs.name as step_nm, opt.name as template_nm 
from   cim_meta_db.dbo.om_extract_element oee
join   cim_meta_db.dbo.om_extract_format oef on oee.extract_format_id = oef.extract_format_id
join   cim_meta_db.dbo.md_column mdc on oee.column_id = mdc.column_id
join   cim_meta_db.dbo.md_table mdt on mdc.table_id = mdt.table_id
join   cim_meta_db.dbo.om_presentation_template opt on oef.Extract_Format_Id=opt.Extract_Format_Id
join    
  (select communication_id, step_id, presentation_template_id from 
  cim_meta_db.dbo.CM_COMM_PACKAGE_PRESENTATION
  group by communication_id, step_id, presentation_template_id) ccpp on opt.Presentation_Template_Id=ccpp.presentation_template_id
join    cim_meta_db.dbo.cm_step cs on ccpp.step_id=cs.step_id
join cim_meta_db.dbo.cm_communication cc on ccpp.communication_id=cc.communication_id
where  mdt.name = 'cim_lhcl_dmc_email_id_vw'



select   distinct 
        (case when oef.local_copy_ind=1 then 'Local' else 'Global' end) as local_ind , mdt.name table_nm, mdc.name col_nm, oef.name Extract_Format_Nm, oef.extract_format_id,
         cc.name as communication_nm, opt.name as template_nm 
from   cim_meta_db.dbo.om_extract_element oee
join   cim_meta_db.dbo.om_extract_format oef on oee.extract_format_id = oef.extract_format_id
join   cim_meta_db.dbo.md_column mdc on oee.column_id = mdc.column_id
join   cim_meta_db.dbo.md_table mdt on mdc.table_id = mdt.table_id
join   cim_meta_db.dbo.om_presentation_template opt on oef.Extract_Format_Id=opt.Extract_Format_Id
join    
  (select communication_id, step_id, presentation_template_id from 
  cim_meta_db.dbo.CM_COMM_PACKAGE_PRESENTATION
  group by communication_id, step_id, presentation_template_id) ccpp on opt.Presentation_Template_Id=ccpp.presentation_template_id
join    cim_meta_db.dbo.cm_step cs on ccpp.step_id=cs.step_id
join cim_meta_db.dbo.cm_communication cc on ccpp.communication_id=cc.communication_id
where  mdt.name = 'cim_lhcl_dmc_email_id_vw'
