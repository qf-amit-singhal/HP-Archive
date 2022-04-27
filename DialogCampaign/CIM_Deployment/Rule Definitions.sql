
select r.Rule_Id
      ,case when r.name = 'Metadata Pre-Run Audit' then 'REPORT' 
            when r.name LIKE 'Promo%' then 'METADATA'
            when r.name LIKE '%CP %' then 'COMMUNICATION'
       end Rule_Type
      ,r.name Rule_Name
      ,r.Description Rule_Descr
      ,r.Pre_Process_Txt
      ,r.Post_Process_Txt
      ,rp.Rule_Parameter_ID
      ,rp.Name Parameter_Name
      ,rp.Description Parameter_Descr
      ,rp.Display_Txt Parameter_Display_Text
      ,rp.Rule_Parameter_Type_Cd
      ,rp.Display_Ord Rule_Paramter_Display_Ord
      ,rq.Sequence_Ord Rule_Query_Ord
      ,rq.name Rule_Query_Name
      ,tsd.Text_Val Rule_Query
from   cim_meta_stage_db.dbo.RM_RULE r
left join cim_meta_stage_db.dbo.RM_RULE_PARAMETER rp on r.rule_id = rp.rule_id
left join cim_meta_stage_db.dbo.RM_RULE_QUERY rq on r.rule_id = rq.rule_id
left join cim_meta_stage_db.dbo.cr_text_storage ts on rq.Sql_Text_Storage_Id = ts.Text_Storage_Id
left join cim_meta_stage_db.dbo.CR_TEXT_STORAGE_DATA tsd on ts.Text_Storage_Id = tsd.Text_Storage_Id
where  (r.Name LIKE 'Promo%' or r.Name LIKE '%CP %' or r.Name = 'Metadata Pre-Run Audit')
order by Rule_Type desc, r.Name, rp.Rule_Parameter_ID, rp.Display_Ord, rq.Sequence_Ord  