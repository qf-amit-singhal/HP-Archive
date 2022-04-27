--SELECT object_definition(default_object_id) AS definition, *
--FROM   sys.columns
--WHERE  object_id = object_id('dbo.LH_REALIZED_LEAD')


/*
drop table cim_hapmdr_output_stage_db.dbo.tmp_stage_column_defaults
drop table cim_hapmdr_output_stage_db.dbo.tmp_prod_column_defaults
*/

use cim_hapmdr_leads_stage_db
go

SELECT db_name() database_name, t.name tablename, c.name column_name, c.column_id, object_definition(default_object_id) AS definition
into   cim_hapmdr_output_stage_db.dbo.tmp_stage_column_defaults
FROM   cim_hapmdr_leads_stage_db.sys.columns c
join   cim_hapmdr_leads_stage_db.sys.tables t on c.object_id = t.object_id
go

use cim_hapmdr_leads_db
go

SELECT db_name() database_name, t.name tablename, c.name column_name, c.column_id, object_definition(default_object_id) AS definition
into   cim_hapmdr_output_stage_db.dbo.tmp_prod_column_defaults
FROM   cim_hapmdr_leads_db.sys.columns c
join   cim_hapmdr_leads_db.sys.tables t on c.object_id = t.object_id
go

select * 
from   cim_hapmdr_output_stage_db.dbo.tmp_stage_column_defaults s
join cim_hapmdr_output_stage_db.dbo.tmp_prod_column_defaults p on s.tablename = p.tablename and s.column_name = p.column_name
where isnull(s.definition,'X') <> isnull(p.definition,'X')
order by 1,2

