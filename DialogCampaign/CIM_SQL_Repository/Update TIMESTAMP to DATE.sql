use cim_meta_stage_db
go

select a.table_id, a.name as table_name, b.name column_name, b.column_id, d.name attribute_name, 
       b.jdbc_type_cd, e.domain_value_name
from   MD_table a
join   MD_column b on a.table_id = b.table_id
join   MD_attribute_column c on b.column_id = c.column_id
join   MD_attribute d on c.attribute_id = d.attribute_id
join   md_domain e on b.jdbc_type_cd = e.domain_cd
where  b.jdbc_type_cd = 93


select * from md_domain where domain_name like 'jdbc%' order by domain_cd

begin transaction 
update MD_column 
set jdbc_type_cd = 91
where column_id in (3080,3100,3739)

select * from MD_column where column_id in (3080,3100,3739)
--rollback
--commit
