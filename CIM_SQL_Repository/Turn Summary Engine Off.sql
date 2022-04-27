update cim_meta_stage_db.dbo.MD_SETTING
set setting_value = 0 --1 = enabled, 0 = disabled
where setting_name = 'SUM_PE_ENABLED_FOR_COMM_PE_IND';


--select comm.name, rcs.update_dttm, sum(lead_summary_cnt)
--from   cim_meta_stage_db.dbo.RT_COMMUNICATION_SUMMARY rcs
--join   cim_meta_stage_db.dbo.CM_COMMUNICATION comm on rcs.communication_id = comm.communication_id
--group  by comm.name, rcs.update_dttm
--order  by rcs.update_dttm desc, comm.name
