/**THIS DID NOT WORK**/
delete from cim_output_stage_db.dbo.temp_cr_folder
go

insert into cim_output_stage_db.dbo.temp_cr_folder
select sf.*
from   cim_meta_stage_Db.dbo.cr_folder sf 
left join cim_meta_Db.dbo.cr_folder pf on sf.Folder_id = pf.Folder_Id
where  pf.folder_id is null
  and (  /*Regeneron Root Folder*/
         (sf.Folder_Id = '2000fgwgfv45' or sf.Parent_Folder_Id = '2000fgwgfv45')  
         /*Regeneron Child Folders*/
         or sf.parent_folder_id in (select folder_id 
                                    from cim_meta_stage_db.dbo.cr_folder 
                                    where parent_folder_id = '2000fgwgfv45')
      )
go


insert into cim_meta_Db.dbo.cr_folder
select * from cim_output_stage_db.dbo.temp_cr_folder


