--insert into cim_output_stage_db.dbo.md_attribute_range
--select ds.name, dev.*
select dev.*
from cim_meta_stage_db.dbo.md_attribute_range dev
left join cim_meta_db.dbo.md_attribute_range prod
on dev.attribute_range_Id=prod.attribute_range_id
and dev.attribute_schema_id = prod.attribute_schema_id
join cim_meta_stage_db.dbo.md_attribute_schema dmas on dmas.attribute_schema_id = dev.attribute_schema_id
join cim_meta_stage_db.dbo.md_schema ds on dmas.output_schema_id = ds.schema_id
where prod.attribute_range_id is null
and  dev.description like 'TRM Disposition%'
and ds.name LIKE 'SFCU%'
order by attribute_id, attribute_schema_id

select * from cim_meta_db.dbo.md_attribute_range prod
where description like 'TRM Disposition%'
order by attribute_id, attribute_schema_id

select count(1) --dev.*
from cim_output_stage_db.dbo.md_attribute_range dev
join cim_meta_db.dbo.md_attribute_range prod
on dev.attribute_range_Id<>prod.attribute_range_id
and dev.attribute_schema_id = prod.attribute_schema_id
and dev.range_primary_val = prod.range_primary_val
and dev.range_group_id = prod.range_group_id
where  dev.description like 'TRM Disposition%'
--order by attribute_id, attribute_schema_id

select dev.*
from cim_meta_stage_db.dbo.md_attribute_range dev
left join cim_meta_db.dbo.md_attribute_range prod
on dev.attribute_range_id=prod.attribute_range_id
and dev.attribute_schema_id = prod.attribute_schema_id
where prod.attribute_range_id is null
and  dev.description like 'TRM Disposition%'
order by attribute_id, attribute_schema_id


select ds.name, s.name, dev.attribute_id, dev.attribute_schema_id, dev.range_group_id, dev.attribute_range_id, dev.description, dev.range_primary_val,
       prod.attribute_id, prod.attribute_schema_id, prod.range_group_id, prod.attribute_range_id, prod.description, prod.range_primary_val       
from cim_output_stage_db.dbo.md_attribute_range dev
join cim_meta_db.dbo.md_attribute_range prod
on dev.attribute_schema_id = prod.attribute_schema_id
and dev.range_primary_val = prod.range_primary_val
and dev.range_group_id = prod.range_group_id
join cim_meta_db.dbo.md_attribute_schema mas on mas.attribute_schema_id = prod.attribute_schema_id
join cim_meta_db.dbo.md_schema s on mas.output_schema_id = s.schema_id

join cim_meta_stage_db.dbo.md_attribute_schema dmas on dmas.attribute_schema_id = dev.attribute_schema_id
join cim_meta_stage_db.dbo.md_schema ds on dmas.output_schema_id = ds.schema_id

where  dev.attribute_range_Id<>prod.attribute_range_id
order by 1,2,3



--delete from cim_output_stage_db.dbo.md_attribute_range

--insert into cim_output_stage_db.dbo.md_attribute_range
select dev.*
from cim_meta_stage_db.dbo.md_attribute_range dev
left join cim_meta_db.dbo.md_attribute_range prod
on dev.attribute_range_Id=prod.attribute_range_id
and dev.attribute_schema_id = prod.attribute_schema_id
join cim_meta_stage_db.dbo.md_attribute_schema dmas on dmas.attribute_schema_id = dev.attribute_schema_id
join cim_meta_stage_db.dbo.md_schema ds on dmas.output_schema_id = ds.schema_id
where prod.attribute_range_id is null
and  dev.description like 'TRM Disposition%'
and ds.name = 'HAP_Customer'
order by attribute_id, attribute_schema_id

--insert into cim_meta_db.dbo.md_attribute_range
select *
from cim_output_stage_db.dbo.md_attribute_range


