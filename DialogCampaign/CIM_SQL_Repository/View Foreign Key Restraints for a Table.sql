use cim_output_stage_db
go

select o.name FK_Name, t.name as TableWithForeignKey, fk.constraint_column_id as FK_PartNo , c.name as ForeignKeyColumn 
from sys.foreign_key_columns as fk
join sys.objects o on fk.constraint_object_id = o.object_id
inner join sys.tables as t on fk.parent_object_id = t.object_id
inner join sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id
--where fk.referenced_object_id = (select object_id from sys.tables where name = 'CR_PROCESS_ENGINE_CAPABILITY')
where t.name = 'CR_PROCESS_ENGINE_CAPABILITY'
order by TableWithForeignKey, FK_PartNo
