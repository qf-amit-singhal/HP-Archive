/*Metadata Audit Report*/
select * from cim_leads_stage_db.dbo.PROMO_MD_PRE_AUDIT

/*Promo 1.1 New Database Work Table*/
select * from cim_output_stage_db.dbo.md_database_promote order by 1


/*Promo 1.2 Source Work Table*/
select * from cim_output_stage_db.dbo.md_server
select * from cim_output_stage_db.dbo.md_database
select * from cim_output_stage_db.dbo.md_table
select * from cim_output_stage_db.dbo.md_column
select * from cim_output_stage_db.dbo.md_table_join_prep
select * from cim_output_stage_db.dbo.md_table_join
select * from cim_output_stage_db.dbo.md_column_join
select * from cim_output_stage_db.dbo.cr_date_range_usage





/*Promo 1.3 Schema Work Table*/
select * from cim_output_stage_db.dbo.md_schema
select * from cim_output_stage_db.dbo.md_schema_element
select * from cim_output_stage_db.dbo.md_schema_column
select * from cim_output_stage_db.dbo.md_schema_relationship
select * from cim_output_stage_db.dbo.md_cross_schema_link
select * from cim_output_stage_db.dbo.md_cross_schema_link_column
select * from cim_output_stage_db.dbo.md_segment_structure
select * from cim_output_stage_db.dbo.md_segment_structure_element

/*Promo 1.4 Attributes Work Table*/
select * from cim_output_stage_db.dbo.md_attr_group
select * from cim_output_stage_db.dbo.md_attribute
select * from cim_output_stage_db.dbo.md_attribute_attr_group
select * from cim_output_stage_db.dbo.md_attribute_schema
select * from cim_output_stage_db.dbo.md_attribute_column
select * from cim_output_stage_db.dbo.md_attribute_range_group
select * from cim_output_stage_db.dbo.md_attribute_range
select * from cim_output_stage_db.dbo.md_range_group_template
select * from cim_output_stage_db.dbo.md_range_template

/*Temporarily delete TRM Disposition ranges. This is a bug in the deployment and creates duplicates preventing MAU from validating*/
delete from cim_output_stage_db.dbo.md_attribute_range 
where description like 'TRM Disposition%'


/*Promo 1.5 CM Classes Work Table*/
/*
Temporarily exclude classes/instances from deploying due to bug in deployment related to folder structures (assuming the classes aren't needed for the deployment
Run to clear work tables can be run to clear these out
*/
select * from cim_output_stage_db.dbo.cm_channel_class
select * from cim_output_stage_db.dbo.cm_channel_instance
select * from cim_output_stage_db.dbo.cm_comm_class
select * from cim_output_stage_db.dbo.cm_comm_subclass
select * from cim_output_stage_db.dbo.cr_folder_entry_base
select * from cim_output_stage_db.dbo.CM_COMM_SUBCLASS_SYSTEM_VALUE



/*Promo 1.6 Seg Form Work Tables*/
select * from cim_output_stage_db.dbo.sm_form
select * from cim_output_stage_db.dbo.sm_subform_attribute_mapping

/*Promo 1.7 EX_Column Work tables*/
select * from cim_output_stage_db.dbo.cr_extension_definition
select * from cim_output_stage_db.dbo.cr_extension_render
select * from cim_output_stage_db.dbo.cr_extension_tab
select * from cim_output_stage_db.dbo.cr_extension_theme
select * from cim_output_stage_db.dbo.cr_extension_source

/*Promo 1.8 Procesing Engines*/
select * from cim_output_stage_db.dbo.cr_job
select * from cim_output_stage_db.dbo.cr_processing_engine
select * from cim_output_stage_db.dbo.cr_process_capability
select * from cim_output_stage_db.dbo.CR_PROCESS_ENGINE_CAPABILITY
select * from cim_output_stage_db.dbo.cr_execution_schedule
select * from cim_output_stage_db.dbo.cr_setting_parameter
