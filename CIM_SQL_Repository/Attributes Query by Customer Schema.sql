use cim_meta_db
go

select at.attribute_id, at.description attribute, md1.domain_value_name attr_type, ms.name schema_nm, ag.name attr_group_nm, ms2.name
from   md_attribute at
join   md_domain md1 on at.attribute_type_cd = md1.domain_cd  and md1.domain_name = 'ATTRIBUTE_TYPE_CD'
join   md_attribute_schema  ats on at.attribute_id  = ats.attribute_id
left join   md_schema ms on ats.output_schema_id = ms.schema_id
left join md_attribute_attr_group aag on at.attribute_id = aag.attribute_id
left join md_attr_group ag on aag.attr_group_id = ag.attr_group_id
left join   md_schema ms2 on ats.criteria_schema_id = ms2.schema_id
where ms.name = 'REG_Customer'
  and ag.name not like 'Scoring%'
order by attr_group_nm, md1.domain_value_name, ms2.name, at.description

