select * from cim_output_stage_db.dbo.md_attribute_range_group



select a.name, arg.*
from   cim_output_stage_db.dbo.md_attribute_range_group arg
join   cim_meta_stage_db.dbo.md_attribute a on arg.attribute_id = a.attribute_id
join   cim_meta_stage_db.dbo.md_attribute_schema ats on ats.Attribute_Schema_Id = arg.Attribute_Schema_Id


select top 1 * from cim_meta_stage_db.dbo.md_attribute_range
select top 1 * from cim_meta_stage_db.dbo.md_attribute_schema
select top 1 * from cim_meta_stage_db.dbo.md_attribute_range_group

select * from cim_output_stage_db.dbo.md_attribute_range


select s.name, ar.*
from   cim_output_stage_db.dbo.md_attribute_range ar
join   cim_meta_stage_db.dbo.md_attribute_schema ats on ats.Attribute_Schema_Id = ar.Attribute_Schema_Id
join   cim_meta_stage_db.dbo.md_attribute_range_group arg on ar.range_group_id = arg.range_group_id
join   cim_meta_stage_db.dbo.md_schema s on ats.output_schema_id = s.schema_id
order by 1, ar.description