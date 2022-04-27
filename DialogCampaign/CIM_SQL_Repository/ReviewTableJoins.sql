/*Globally Replace Client Prefix: SFCU*/

use cim_meta_stage_db
go

if object_id('tempdb..##SurveyCrossSchemaLinks') is not null drop table ##SurveyCrossSchemaLinks
select distinct t.name table_name 
--select mdcs.cross_schema_link_id, mdcs.name cross_schema_link, ps.name primary_schema, ss.name secondary_schema, t.name table_name 
into ##SurveyCrossSchemaLinks
from   dbo.MD_CROSS_SCHEMA_LINK mdcs
left join dbo.md_schema ps on mdcs.primary_schema_id = ps.schema_id
left join dbo.md_schema ss on mdcs.secondary_schema_id = ss.schema_id
left join dbo.md_table t on mdcs.table_id = t.table_id
left join dbo.md_database d on t.database_id = d.database_id
where ss.name like '%survey%'
  and t.name not like 'test%'
  and ss.name not like 'test%'
  and d.name like '%SFCU%'
--order by ps.name, ss.name, mdcs.name

if object_id('tempdb..##AttributeCrossSchemaLinks') is not null drop table ##AttributeCrossSchemaLinks
select distinct t.name table_name 
--select mdcs.cross_schema_link_id, mdcs.name cross_schema_link, ps.name primary_schema, ss.name secondary_schema, t.name table_name 
into ##AttributeCrossSchemaLinks
from   dbo.MD_CROSS_SCHEMA_LINK mdcs
left join dbo.md_schema ps on mdcs.primary_schema_id = ps.schema_id
left join dbo.md_schema ss on mdcs.secondary_schema_id = ss.schema_id
left join dbo.md_table t on mdcs.table_id = t.table_id
left join dbo.md_database d on t.database_id = d.database_id
where ss.name like '%attribute%'
  and t.name not like 'test%'
  and ss.name not like 'test%'
  and d.name like '%SFCU%'
--order by ps.name, ss.name, mdcs.name

if object_id('tempdb..##CommunicationCrossSchemaLinks') is not null drop table ##CommunicationCrossSchemaLinks

select distinct t.name table_name 
--select mdcs.cross_schema_link_id, mdcs.name cross_schema_link, ps.name primary_schema, ss.name secondary_schema, t.name table_name , d.name
into ##CommunicationCrossSchemaLinks
from   dbo.MD_CROSS_SCHEMA_LINK mdcs
left join dbo.md_schema ps on mdcs.primary_schema_id = ps.schema_id
left join dbo.md_schema ss on mdcs.secondary_schema_id = ss.schema_id
left join dbo.md_table t on mdcs.table_id = t.table_id
left join dbo.md_database d on t.database_id = d.database_id
where ss.name like '%communication%'
  and t.name not like 'test%'
  and ss.name not like 'test%'
  and d.name like '%SFCU%'
--order by ps.name, ss.name, mdcs.name


if object_id('tempdb..##PrefCrossSchemaLinks') is not null drop table ##PrefCrossSchemaLinks
select distinct t.name table_name 
--select mdcs.cross_schema_link_id, mdcs.name cross_schema_link, ps.name primary_schema, ss.name secondary_schema, t.name table_name 
into ##PrefCrossSchemaLinks
from   dbo.MD_CROSS_SCHEMA_LINK mdcs
left join dbo.md_schema ps on mdcs.primary_schema_id = ps.schema_id
left join dbo.md_schema ss on mdcs.secondary_schema_id = ss.schema_id
left join dbo.md_table t on mdcs.table_id = t.table_id
left join dbo.md_database d on t.database_id = d.database_id
where ss.name like '%pref%'
  and t.name not like 'test%'
  and ss.name not like 'test%'
  and d.name like '%SFCU%'
--order by ps.name, ss.name, mdcs.name



if object_id('tempdb..##BadTableJoins') is not null drop table ##BadTableJoins
select *
into   ##BadTableJoins
from (select 'SurveySchema' JoinType, mtj.table_join_id, mcj.column_join_id, mtj.Description, 
             s_left.name Left_Server_Name, t_left.name Left_Table_Name, c_left.name Left_Column_Name, 
             s_right.name Right_Server_Name, t_right.name Right_Table_Name, c_right.name Right_Column_Name
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
      where  t_left.name in (select table_name from ##SurveyCrossSchemaLinks) 
        and  t_right.name in (select table_name from ##SurveyCrossSchemaLinks)
        and  (db_left.name like 'SFCU%' or db_right.name like 'SFCU%')
      union all
      select 'AttributeSchema' JoinType, mtj.table_join_id, mcj.column_join_id, mtj.Description,
             s_left.name Left_Server_Name, t_left.name Left_Table_Name, c_left.name Left_Column_Name, 
             s_right.name Right_Server_Name, t_right.name Right_Table_Name, c_right.name Right_Column_Name
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
      where  t_left.name in (select table_name from ##AttributeCrossSchemaLinks) 
        and  t_right.name in (select table_name from ##AttributeCrossSchemaLinks) 
        and  (db_left.name like 'SFCU%' or db_right.name like 'SFCU%')
      union all
      select 'CommunicationSchema' JoinType, mtj.table_join_id, mcj.column_join_id, mtj.Description,
              s_left.name Left_Server_Name, t_left.name Left_Table_Name, c_left.name Left_Column_Name, 
              s_right.name Right_Server_Name, t_right.name Right_Table_Name, c_right.name Right_Column_Name
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
      where  t_left.name in (select table_name from ##CommunicationCrossSchemaLinks) 
        and  t_right.name in (select table_name from ##CommunicationCrossSchemaLinks)
        and  (db_left.name like 'SFCU%' or db_right.name like 'SFCU%')
      union all
      select 'PrefSchema' JoinType, mtj.table_join_id, mcj.column_join_id, mtj.Description, 
             s_left.name Left_Server_Name, t_left.name Left_Table_Name, c_left.name Left_Column_Name, 
             s_right.name Right_Server_Name, t_right.name Right_Table_Name, c_right.name Right_Column_Name
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
      where  t_left.name in (select table_name from ##PrefCrossSchemaLinks) 
        and  t_right.name in (select table_name from ##PrefCrossSchemaLinks)
        and  (db_left.name like 'SFCU%' or db_right.name like 'SFCU%')
      union all
      select 'ARM Joins and Irrelevant Joins' JoinType, mtj.table_join_id, mcj.column_join_id, mtj.Description,
              s_left.name Left_Server_Name, t_left.name Left_Table_Name, c_left.name Left_Column_Name, 
              s_right.name Right_Server_Name, t_right.name Right_Table_Name, c_right.name Right_Column_Name
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
      where ( s_left.name = 'ARM HomeServer' and s_right.name <> 'ARM HomeServer'
              and  t_right.name not like '%MASTER%'
              and  t_right.name not in ('CIM_EMAIL_ACTIVITY_VW')
              and  (db_left.name like 'SFCU%' or db_right.name like 'SFCU%')
             ) OR
            ( s_left.name <> 'ARM HomeServer' and s_right.name = 'ARM HomeServer'
              and  t_left.name not like '%MASTER%'
              and  t_left.name not in ('CIM_EMAIL_ACTIVITY_VW')
              and  (db_left.name like 'SFCU%' or db_right.name like 'SFCU%')
              and t_right.name not in ('LH_COLLATERAL_HISTORY','LH_CURRENT_LEAD','LH_LEAD_KEY_HISTORY','LH_REALIZED_LEAD',
                                       'LH_SELECTION_VARIABLE','LH_UNREALIZED_LEAD','RT_SCORE')      
             ) OR
            ( s_left.name = 'ARM HomeServer' and s_right.name = 'ARM HomeServer'
              and  (t_left.name like 'CIM%' and t_right.name like 'CIM%')
              and  t_left.name not in ('CIM_COMM_CLASS','CIM_COMM_SUBCLASS','CIM_STEP','CIM_COMMUNICATION','CIM_STEP_TYPE','CIM_EVAL_TIMER')
              and  t_right.name not in ('CIM_COMM_CLASS','CIM_COMM_SUBCLASS','CIM_STEP','CIM_COMMUNICATION','CIM_STEP_TYPE','CIM_EVAL_TIMER')
              and  (db_left.name like 'SFCU%' or db_right.name like 'SFCU%')
            ) 
) x

select * from ##BadTableJoins
order by JoinType, Left_Server_Name, Left_Table_Name, Right_Table_Name


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
where  (t_left.name in ( select t.name table_name 
                        from   dbo.MD_CROSS_SCHEMA_LINK mdcs
                        left join dbo.md_table t on mdcs.table_id = t.table_id
                        left join dbo.md_database d on t.database_id = d.database_id
                        where d.name like '%SFCU%'
                       ) 
  or  t_right.name in (select t.name table_name 
                        from   dbo.MD_CROSS_SCHEMA_LINK mdcs
                        left join dbo.md_table t on mdcs.table_id = t.table_id
                        left join dbo.md_database d on t.database_id = d.database_id
                        where d.name like '%SFCU%') )
  and  (db_left.name like '%SFCU%' or db_right.name like '%SFCU%')
order by 1,2,3,4
        
