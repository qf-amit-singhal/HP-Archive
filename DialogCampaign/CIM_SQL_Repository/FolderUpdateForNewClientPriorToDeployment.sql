/*====================================================================================
1. Create the folder in production
   - Log into CIM Prod
   - Go to Admin on left nav menu
   - Launch Folders
   - Create new folder under trm (same name as stage)
   
2. In Query #1, change folder name and run to view folder ids in both stage and prod

3. Update folder ids in the three places in Query #2.  The folder id and folder path should
   have the folder id of the STAGE folder.  The where clause, the folder id of the PROD
   folder.  Uncomment the update statement,  select from begin to after there where and run.
   Rerun the queries in #1.  If look good, run commit, if not, run rollback. 
====================================================================================*/


/*====================================================================================
#1 View folder ids for Stage and Prod
====================================================================================*/
select pf.name parent_folder, f.* 
from cim_meta_stage_db.dbo.cr_folder f
left join cim_meta_stage_db.dbo.cr_folder pf on f.parent_folder_id = pf.folder_id
where f.name = 'HAP'

select pf.name parent_folder, f.* 
from cim_meta_db.dbo.cr_folder f
left join cim_meta_db.dbo.cr_folder pf on f.parent_folder_id = pf.folder_id
where f.name = 'HAP'



begin transaction
--update cim_meta_db.dbo.cr_folder
--set folder_id = '2000gffcd0m2',
--    id_path = 'folder root:,2000gffcd0m2'
--where folder_id = '1000gdz4z927'


--rollback
--commit



