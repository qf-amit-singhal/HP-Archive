use cim_meta_stage_db
go

select oee.extract_format_id, oee.extract_element_id, oef.name extract_format_nm, oee.name extract_element_nm,
       case oee.name
          when 'user.customAttribute.alternate' then 'user.customAttribute.alternateEmail' 
          when 'user.CustomAttribute.HOUSEHOLD' then 'user.CustomAttribute.HOUSEHOLD_ID'
          when 'user.CustomAttribute.ACCT_CONT' then 'user.CustomAttribute.ACCT_CONT_ID'
          when 'user.CustomAttribute.Leaf_Segm' then 'user.CustomAttribute.Leaf_Segment_Id'
          when 'user.CustomAttribute.Collatera' then 'user.CustomAttribute.Collateral_Id'
          when 'user.CustomAttribute.Communica' then 'user.CustomAttribute.Communication_Id'
          when 'user.CustomAttribute.Lead_Key_' then 'user.CustomAttribute.Lead_Key_Id' 
          else oee.name
       end new_extract_element_nm
from   om_extract_element oee
join   om_extract_format oef on oee.extract_format_id = oef.extract_format_id
join   md_column mdc on oee.column_id = mdc.column_id
join   md_table mdt on mdc.table_id = mdt.table_id
where  oef.name = 'EAH Reminder DMC Extract Format'

                    
update om_extract_element 
set name = 
     case name
          when 'user.customAttribute.alternate' then 'user.customAttribute.alternateEmail' 
          when 'user.CustomAttribute.HOUSEHOLD' then 'user.CustomAttribute.HOUSEHOLD_ID'
          when 'user.CustomAttribute.ACCT_CONT' then 'user.CustomAttribute.ACCT_CONT_ID'
          when 'user.CustomAttribute.Leaf_Segm' then 'user.CustomAttribute.Leaf_Segment_Id'
          when 'user.CustomAttribute.Collatera' then 'user.CustomAttribute.Collateral_Id'
          when 'user.CustomAttribute.Communica' then 'user.CustomAttribute.Communication_Id'
          when 'user.CustomAttribute.Lead_Key_' then 'user.CustomAttribute.Lead_Key_Id' 
          else name
     end
where extract_element_id IN ('2000fv1grn8x',
'2000fv1grn91',
'2000fv1grnnp',
'2000fv1grnnq',
'2000fv1grnnr',
'2000fv1grp1m',
'2000fv1grp1n')





select oee.extract_format_id, oee.extract_element_id, oef.name extract_format_nm, oee.name extract_element_nm,
       case oee.name
          when 'user.customAttribute.alternate' then 'user.customAttribute.alternateEmail' 
          when 'user.CustomAttribute.HOUSEHOLD' then 'user.CustomAttribute.HOUSEHOLD_ID'
          when 'user.CustomAttribute.ACCT_CONT' then 'user.CustomAttribute.ACCT_CONT_ID'
          when 'user.CustomAttribute.Leaf_Segm' then 'user.CustomAttribute.Leaf_Segment_Id'
          when 'user.CustomAttribute.Collatera' then 'user.CustomAttribute.Collateral_Id'
          when 'user.CustomAttribute.Communica' then 'user.CustomAttribute.Communication_Id'
          when 'user.CustomAttribute.Lead_Key_' then 'user.CustomAttribute.Lead_Key_Id' 
          else oee.name
       end new_extract_element_nm
from   om_extract_element oee
join   om_extract_format oef on oee.extract_format_id = oef.extract_format_id
join   md_column mdc on oee.column_id = mdc.column_id
join   md_table mdt on mdc.table_id = mdt.table_id
where  oef.name = 'EAH Reminder DMC Extract Format'