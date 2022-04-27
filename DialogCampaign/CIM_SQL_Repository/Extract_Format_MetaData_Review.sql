

select s.name Contact_Schema, oef.extract_format_id, oef.name extract_format,
       oee.extract_element_id, oee.name extract_element,
       jdbc.domain_value_name jdbc_type_cd,
       t.name table_name, c.name column_name, 
       et.domain_value_name element_type, oee.data_default_value_txt, oef.*
from   cim_meta_stage_db.dbo.om_extract_format oef 
join   cim_meta_stage_db.dbo.om_extract_element oee on oef.extract_format_id = oee.extract_format_id
join   cim_meta_stage_db.dbo.md_domain jdbc on oee.jdbc_type_cd = jdbc.domain_cd  and jdbc.domain_name = 'JDBC_TYPE_CD'
left join cim_meta_stage_db.dbo.md_column c on oee.column_id = c.column_id
left join cim_meta_stage_db.dbo.md_table t on c.table_id = t.table_id
join   cim_meta_stage_db.dbo.md_domain et on oee.element_type_cd = et.domain_cd and et.domain_name = 'FORMAT_ELEMENT_TYPE_CD'
join   cim_meta_stage_db.dbo.md_schema s on s.schema_id = oef.contact_schema_id
where  oef.extract_format_id = '2000fv1grn8v'

select s.name Contact_Schema, oef.extract_format_id, oef.name extract_format, 
       (case when oef.local_copy_ind=1 then 'Local' else 'Global' end) as extract_local_ind,
       --(case when opt.local_copy_ind=1 then 'Local' else 'Global' end) as opt_local_ind,
       ccpp.* 
from   cim_meta_stage_db.dbo.om_extract_format oef 
join   cim_meta_stage_db.dbo.md_schema s on s.schema_id = oef.contact_schema_id
left join   cim_meta_stage_db.dbo.om_presentation_template opt on oef.Extract_Format_Id=opt.Extract_Format_Id
left join  (select distinct cc.name comm_name, cc.communication_id, cs.step_id, cs.name step, ccpp.presentation_template_id 
            from   cim_meta_stage_db.dbo.CM_COMM_PACKAGE_PRESENTATION ccpp
            join   cim_meta_stage_db.dbo.cm_step cs on ccpp.step_id=cs.step_id
            join   cim_meta_stage_db.dbo.cm_communication cc on ccpp.communication_id=cc.communication_id
            ) ccpp on opt.Presentation_Template_Id=ccpp.presentation_template_id
where  oef.name = 'EAH Reminder DMC Extract Format'