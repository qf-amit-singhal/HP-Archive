/*Globally Replace Client Prefix to query configuration for a specific client*/

use cim_meta_stage_db
go

/*Review Tables/ Columns added for Client with Primary Keys*/
select d.name db_name, t.name table_name, ti.name table_time_interval, c.name column_name, c.primary_key_ind, c.*
from   md_table t 
join   md_database d on t.database_id = d.database_id
join   md_column c on t.table_id = c.table_id 
left join md_time_interval ti on t.time_interval_id = ti.time_interval_id
where  (d.name like '%HMCMDR%VIEWS%' or d.name = 'HMCMDR_CIM_DA') 
order  by d.name desc, t.name, c.primary_key_ind desc, c.name

/*Review All Table Joins*/
select s_left.name Left_Server_Name, t_left.name Left_Table_Name, c_left.name Left_Column_Name, 
       s_right.name Right_Server_Name, t_right.name Right_Table_Name, c_right.name Right_Column_Name,
       mtj.table_join_id, mcj.column_join_id, mtj.Description
from   dbo.md_table_join mtj
join   dbo.md_table t_left on mtj.left_table_id = t_left.table_id
join   dbo.md_table t_right on mtj.right_table_id = t_right.table_id
join   dbo.md_column_join mcj on mtj.table_join_id = mcj.table_join_id 
join   dbo.md_column c_left on mcj.left_column_id = c_left.column_id
join   dbo.md_column c_right on mcj.right_column_id = c_right.column_id
join   dbo.md_database db_left on t_left.database_id = db_left.database_id
join   dbo.md_database db_right on t_right.database_id = db_right.database_id
join   dbo.md_server s_left on s_left.server_id = db_left.server_id
join   dbo.md_server s_right on s_right.server_id = db_right.server_id
where  (db_left.name like '%HMC%' or db_right.name like '%HMC%')
  /*The below should filter tables that were mapped by us for the client, and ignore CIM system table joins*/
  and  (s_left.name like '%HMC%' or (s_left.name = 'ARM HomeServer' and t_left.name like 'CIM%'))
order by Left_Server_Name,Left_Table_Name, Right_Table_Name, Right_Column_Name
 
/*Schema Set-Up Review*/
select se.schema_element_id,  s.name schema_nm, s.description schema_descr, sec.domain_value_name security_type_code, 
       se.name schema_element_nm, se.description schema_element_descr, cache.domain_value_name segmentation_cache, ss.name segment_structure,
       se.completeness_ind, pk.name pk_complement, t.name master_table_nm, col_mt.name key_column, col_desc.name descr_column, se.Display_ord
from   md_schema s
left join   md_domain sec on s.security_type_cd = sec.domain_cd and sec.domain_name = 'SECURITY_TYPE_CD'
join   md_schema_element se on se.schema_id = s.schema_id
left join   md_domain cache on se.segmentation_cache_cd = cache.domain_cd and cache.domain_name = 'CACHE_CD'
join   md_segment_structure ss on se.segment_structure_id = ss.segment_structure_id
join   md_table t on se.master_table_id = t.table_id
join   md_schema_column sc_mt on se.schema_element_id = sc_mt.schema_element_id and sc_mt.Schema_Column_Usage_Cd = 1
join   md_column col_mt on sc_mt.column_id = col_mt.column_id 
join   md_schema_column sc_desc on se.schema_element_id = sc_desc.schema_element_id and sc_desc.Schema_Column_Usage_Cd = 2
join   md_column col_desc on sc_desc.column_id = col_desc.column_id 
left join md_schema_element pk on se.completor_element_id = pk.schema_element_id
where s.name like 'HMC%'
order by s.name, se.display_ord;

/*Cross Schema Links*/
select mdcs.cross_schema_link_id, mdcs.name cross_schema_nm,  mdcs.description cross_schema_descr,
       ps.name primary_schema, pse.name primary_schema_element, 
       ss.name secondary_schema, sse.name secondary_schema_element, t.name table_name 
from   md_cross_schema_link mdcs
join md_schema ps on mdcs.primary_schema_id = ps.schema_id
join md_schema ss on mdcs.secondary_schema_id = ss.schema_id
join md_table t on mdcs.table_id = t.table_id
join md_schema_element pse on mdcs.primary_schema_element_id = pse.schema_element_id 
join md_schema_element sse on mdcs.secondary_schema_element_id = sse.schema_element_id 
where ps.name like 'HMC%'
  and ss.name NOT LIKE 'Analytic Scores%'
order by ps.name, ss.name, mdcs.name


/*Attributes*/
select at.attribute_id, at.name attr_nm, at.description attr_descr, 
       md1.domain_value_name attr_type, ag.name attr_group_nm,
       ms.name primary_schema_nm, se.name primary_schema_element,
       ms2.name secondary_schema_nm, se2.name secondary_schema_element ,
       t.name table_name, col.name column_name
from   md_attribute at
join   md_domain md1 on at.attribute_type_cd = md1.domain_cd  and md1.domain_name = 'ATTRIBUTE_TYPE_CD'
join   md_attribute_attr_group aag on at.attribute_id = aag.attribute_id
join   md_attr_group ag on aag.attr_group_id = ag.attr_group_id
join   md_attribute_schema ats on at.attribute_id  = ats.attribute_id
join   md_schema ms on ats.output_schema_id = ms.schema_id
join   md_schema_element se on ats.Output_Schema_Element_Id = se.Schema_Element_Id
join   md_schema ms2 on ats.criteria_schema_id = ms2.schema_id
join   md_schema_element se2 on ats.Criteria_Schema_Element_Id = se2.Schema_Element_Id
join   md_attribute_column ac on at.attribute_id = ac.attribute_id and ats.attribute_schema_id = ac.attribute_schema_id
join   md_table t on ac.table_id = t.table_id 
join   md_column col on ac.column_id = col.column_id
where ms.name like 'HMC%'
  and ag.name not like 'Scoring%'
order by attr_group_nm, md1.domain_value_name, ms2.name, at.description

/*Attribute Ranges*/
select at.attribute_id, at.name attr_nm, at.description attr_descr,
       op.name operator, ar.range_primary_val, ar.description range_display
from   md_attribute at
join   md_domain md1 on at.attribute_type_cd = md1.domain_cd  and md1.domain_name = 'ATTRIBUTE_TYPE_CD'
join   md_attribute_attr_group aag on at.attribute_id = aag.attribute_id
join   md_attr_group ag on aag.attr_group_id = ag.attr_group_id
join   md_attribute_schema ats on at.attribute_id  = ats.attribute_id
join   md_schema ms on ats.output_schema_id = ms.schema_id
join   md_schema_element se on ats.Output_Schema_Element_Id = se.Schema_Element_Id
join   md_schema ms2 on ats.criteria_schema_id = ms2.schema_id
join   md_schema_element se2 on ats.Criteria_Schema_Element_Id = se2.Schema_Element_Id
join   md_attribute_column ac on at.attribute_id = ac.attribute_id and ats.attribute_schema_id = ac.attribute_schema_id
join   md_table t on ac.table_id = t.table_id 
join   md_column col on ac.column_id = col.column_id
join   md_attribute_range_group arg on ats.attribute_id = arg.attribute_id and ats.attribute_schema_id = arg.attribute_schema_id
join   md_attribute_range ar on arg.range_group_id = ar.Range_Group_Id
join   cd_operator op on ar.range_operator_cd = op.operator_cd
where ms.name like 'HMC%'
  and ag.name not like 'Scoring%'
order by at.name, md1.domain_value_name, ms2.name, at.description






