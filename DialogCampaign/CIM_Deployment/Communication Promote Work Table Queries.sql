/*CP 1.00 Comm to Promote and Start*/
select c.name, o.* from cim_output_stage_db.dbo.cm_communication_promote o
left join cim_meta_stage_db.dbo.cm_communication c on o.communication_id = c.communication_id;
select * from cim_output_stage_db.dbo.cr_folder_entry


/*CP 1.01 Data Source Wk Tables*/
select * from cim_output_stage_db.dbo.cr_text_storage 
select * from cim_output_stage_db.dbo.cr_text_storage_data
select * from cim_output_stage_db.dbo.ds_data_source_column
select * from cim_output_stage_db.dbo.ds_data_source
select * from cim_output_stage_db.dbo.cr_folder_entry

/*CP 1.02 Segments*/
select * from cim_output_stage_db.dbo.sm_segment
select * from cim_output_stage_db.dbo.sm_selection_plan
select * from cim_output_stage_db.dbo.sm_selection_criteria_set
select * from cim_output_stage_db.dbo.sm_selection
select * from cim_output_stage_db.dbo.cr_date_range
select * from cim_output_stage_db.dbo.sm_selection_range_value
select * from cim_output_stage_db.dbo.sm_schema_element_value
select * from cim_output_stage_db.dbo.cr_folder_entry

/*CP 1.03 Segment Plan*/
select * from cim_output_stage_db.dbo.sm_segment_plan
select * from cim_output_stage_db.dbo.sm_pick_best_criteria
select * from cim_output_stage_db.dbo.sm_segment_plan_clip_attribute
select * from cim_output_stage_db.dbo.sm_logical_segment
select * from cim_output_stage_db.dbo.sm_segment_relationship
select * from cim_output_stage_db.dbo.cr_folder_entry

/*CP 1.05 Comm and Comm Plan*/
select * from cim_output_stage_db.dbo.cm_communication
select * from cim_output_stage_db.dbo.cm_communication_comm_plan
select * from cim_output_stage_db.dbo.cm_comm_plan
select * from cim_output_stage_db.dbo.cr_folder_entry

/*CP 1.06 Output Templates and Formats*/
select * from cim_output_stage_db.dbo.OM_EXTRACT_FORMAT
select * from cim_output_stage_db.dbo.OM_EXTRACT_ELEMENT
select * from cim_output_stage_db.dbo.om_delivery
select * from cim_output_stage_db.dbo.om_presentation_template
select * from cim_output_stage_db.dbo.om_email_address
select * from cim_output_stage_db.dbo.om_template_email_address
select * from cim_output_stage_db.dbo.om_template_email_attach
select * from cim_output_stage_db.dbo.om_presentation_template_sort
select * from cim_output_stage_db.dbo.cm_email
select * from cim_output_stage_db.dbo.cm_sms
select * from cim_output_stage_db.dbo.cr_folder_entry

/*CP 1.07 Step, Msg, Collat, Resp Masters*/
select * from cim_output_stage_db.dbo.cm_step
select * from cim_output_stage_db.dbo.cm_message
select * from cim_output_stage_db.dbo.cm_collateral
select * from cim_output_stage_db.dbo.cm_response
select * from cim_output_stage_db.dbo.cr_folder_entry

/*CP 1.08 Step-Msg Contents*/
select * from cim_output_stage_db.dbo.cm_comm_package
select * from cim_output_stage_db.dbo.cm_comm_package_collateral
select * from cim_output_stage_db.dbo.cm_comm_package_presentation
select * from cim_output_stage_db.dbo.cm_comm_plan_message
select * from cim_output_stage_db.dbo.cm_comm_plan_step
select * from cim_output_stage_db.dbo.cm_message_collateral
select * from cim_output_stage_db.dbo.cm_message_presentation
select * from cim_output_stage_db.dbo.cm_step_message
select * from cim_output_stage_db.dbo.cm_step_response

/*CP 1.09 Ex Tables*/
select * from cim_output_stage_db.dbo.ex_collateral
select * from cim_output_stage_db.dbo.ex_communication
select * from cim_output_stage_db.dbo.ex_logical_segment
select * from cim_output_stage_db.dbo.ex_step

/*CP 1.10 CR and Recency*/
select * from cim_output_stage_db.dbo.cr_execution_schedule
select * from cim_output_stage_db.dbo.cm_primary_element_recency


