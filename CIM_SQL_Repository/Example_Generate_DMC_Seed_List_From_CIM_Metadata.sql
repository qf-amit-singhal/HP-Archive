USE CIM_[APPCODE]_OUTPUT_STAGE_DB
GO

--IF OBJECT_ID('DMC_SEED_LIST') IS NOT NULL DROP TABLE DMC_SEED_LIST
--GO

--CREATE TABLE DMC_SEED_LIST (
--  SEED_CONT_ID  int IDENTITY(9,1),
--  FIRST_NAME    varchar(30),
--  LAST_NAME     varchar(30),
--  EMAIL_ADDRESS varchar(255),
--  SEED_TYPE     varchar(255)
--)
--GO

--ALTER TABLE DMC_SEED_LIST ADD CONSTRAINT DMC_SEED_LIST__SEEDTYPE_CK
--    CHECK (SEED_TYPE IN ('INTERNAL','EXTERNAL'))
--GO

    
--TRUNCATE TABLE DMC_SEED_LIST

IF OBJECT_ID('TempDB..#Seeds') IS NOT NULL DROP TABLE #Seeds
GO

SELECT FIRST_NAME, LAST_NAME, EMAIL_ADDRESS, SEED_TYPE
INTO   #Seeds
FROM   DMC_SEED_LIST
WHERE  1 = 2
GO

INSERT INTO #Seeds (FIRST_NAME, LAST_NAME, EMAIL_ADDRESS, SEED_TYPE) 
  VALUES --Internal Emails
         ('Angela', 'Plafcan', 'angela.plafcan@dialog-direct.com', 'INTERNAL')
       , ('Rowena', 'Gumayan', 'Rowena.Gumayan@dialog-direct.com', 'INTERNAL')
       , ('Andrew', 'Brubaker','Andrew.Brubaker@dialog-direct.com', 'INTERNAL')
       , ('ShivaKumar', 'Pocha','ShivaKumar.Pocha@dialog-direct.com', 'INTERNAL')
       , ('Michelle', 'Austin-Dor','Michelle.Austin-Dor@dialog-direct.com', 'INTERNAL')
       , ('Lindsay', 'Schroeder','Lindsay.Schroeder@dialog-direct.com', 'INTERNAL')
       --, ('Galina', 'Petrenko','Galina.Petrenko@dialog-direct.com', 'INTERNAL')
       --, ('Dave', 'Moran','Dave.Moran@dialog-direct.com', 'INTERNAL')
       /*No Name for Personalization Test*/
       , ('', 'Brubaker','Andrew.Brubaker@dialog-direct.com', 'INTERNAL')
       /*Internal Personal Emails*/
       , ('Angela', 'Plafcan', 'plafcan21@gmail.com', 'INTERNAL')
       , ('Angela', 'Plafcan', 'plafcan21@yahoo.com', 'INTERNAL')
       , ('Angela', 'Plafcan', 'plafcan21@hotmail.com', 'INTERNAL')       
       , ('Andrew', 'Brubaker','brubandy@verizon.net', 'INTERNAL')
       , ('Andrew', 'Brubaker','brubandy@yahoo.com', 'INTERNAL')
       , ('Andrew', 'Brubaker','brubandy@gmail.com', 'INTERNAL')
       , ('Andrew', 'Brubaker','brubandy@hotmail.com', 'INTERNAL')       
       , ('Rowena', 'Gumayan', 'rigemployment@yahoo.com', 'INTERNAL')
       , ('Lindsay', 'Schroeder','madmadlaw@yahoo.com', 'INTERNAL')
       , ('Lindsay', 'Schroeder','plumlabshelp@gmail.com', 'INTERNAL')
       /*Bad Emails*/
       --, ('Angela', 'Plafcan', 'plafcan21@test', 'INTERNAL')
       --, ('Andrew', 'Brubaker','andrew.e.brubaker@ml.com', 'INTERNAL')
       --, ('Andrew', 'Brubaker','andrew.brubaker@dialog-direct.biz', 'INTERNAL')
       /*External Emails*/
       --, ('', '','', 'EXTERNAL')
       
GO

/*INSERT NEW*/
INSERT INTO DMC_SEED_LIST (FIRST_NAME, LAST_NAME, EMAIL_ADDRESS, SEED_TYPE) 
SELECT *
FROM   #Seeds s
WHERE  NOT EXISTS (SELECT 1
                   FROM   DMC_SEED_LIST dmc
                   WHERE  s.EMAIL_ADDRESS = dmc.EMAIL_ADDRESS)
GO

/*DELETE REMOVED SEEDS*/
DELETE FROM DMC_SEED_LIST 
WHERE EMAIL_ADDRESS NOT IN (SELECT EMAIL_ADDRESS FROM #Seeds)
GO

--select * from DMC_SEED_LIST

       
/*Eylea Patient CRM Campaign Seeds*/
if object_id('DMC_Seed_View') is not null drop view DMC_Seed_View
go

create view DMC_Seed_View as 
select distinct
       cast(seed_cont_id as varchar) + '_' + ec.reg_Internal_Code + '_' + replace(replace(replace(replace(convert(varchar(20),getdate(),121),' ',''),'.',''),'-',''),':','') + '@regseed.dialogdirect.com' [user.Email]
      ,seeds.email_address as [user.customAttribute.alternateEmail]
      ,'REGENERON' [user.CustomAttribute.Client]
      ,excomm.reg_comm_account [user.CustomAttribute.ACC_Name]
      ,null as [user.CustomAttribute.HOUSEHOLD_ID]
      --negative contact ids when in production so that responses from test emails don't match to IMS
      ,seeds.seed_cont_id * -1 [user.CustomAttribute.Cont_Id]
      ,null as [user.CustomAttribute.ACCT_CONT_ID]
      ,null as [user.CustomAttribute.Lead_Key_Id]
      ,log_seg.Logical_Segment_Id as [user.CustomAttribute.Leaf_Segment_Id] -- seeds won't have a leaf_segment_id
      ,pkg_collat.Collateral_Id as [user.CustomAttribute.Collateral_Id]
      ,comm.Communication_Id as [user.CustomAttribute.Communication_Id]
      ,step.Step_Id as [user.CustomAttribute.Step_Id]
      ,comm.name as [user.CustomAttribute.CommName]
      ,collat.name as [user.CustomAttribute.CollatNm]
      ,seg.name as [user.CustomAttribute.SegName]
      ,ec.reg_Internal_Code as [user.CustomAttribute.COMM_CODE]
      ,null as [user.CustomAttribute.Subject]
      ,convert(varchar(10),getdate(),120) as [user.CustomAttribute.CommDate]
      ,null as [user.Title]
      ,seeds.first_name as [user.FirstName]
      ,seeds.last_name as [user.LastName]
      ,null as [user.CustomAttribute.Phone]
      ,null as [user.CustomAttribute.Addr1]
      ,null as [user.CustomAttribute.Addr2]
      ,null as [user.CustomAttribute.City]
      ,null as [user.CustomAttribute.State]
      ,null as [user.ZipCode]
      ,null as [user.CustomAttribute.Custom1]
      ,null as [user.CustomAttribute.Custom2]
      ,null as [user.CustomAttribute.Custom3]
      ,null as [user.CustomAttribute.Custom4]
      ,null as [user.CustomAttribute.Custom5]
      ,null as [user.CustomAttribute.Custom6]
      ,null as [user.CustomAttribute.Custom7]
      ,null as [user.CustomAttribute.Custom8]
      ,null as [user.CustomAttribute.Custom9]
      ,null as [user.CustomAttribute.Custom10]
      ,'Y' as [user.CustomAttribute.EmailOpen]
from cim_meta_stage_db.dbo.cm_communication comm 
left join cim_meta_stage_db.dbo.ex_communication excomm on comm.communication_id = excomm.communication_id
join cim_meta_stage_db.dbo.cm_comm_package comm_pkg on comm.Communication_Id=comm_pkg.Communication_Id
join cim_meta_stage_db.dbo.cm_comm_package_collateral pkg_collat on comm_pkg.package_id=pkg_collat.package_id
join cim_meta_stage_db.dbo.cm_step step on comm_pkg.step_id = step.step_id
join cim_meta_stage_db.dbo.ex_step exstep on step.step_id = exstep.step_id
join cim_meta_stage_db.dbo.CM_COLLATERAL collat on pkg_collat.collateral_id=collat.collateral_id
join cim_meta_stage_db.dbo.EX_COLLATERAL ec on collat.Collateral_Id = ec.Collateral_Id
join cim_meta_stage_db.dbo.sm_logical_segment log_seg on comm_pkg.Logical_Segment_Id=log_seg.Logical_Segment_Id
join cim_meta_stage_db.dbo.sm_segment seg on log_seg.Segment_Id=seg.Segment_Id
cross join DMC_SEED_LIST seeds
where  comm.Communication_Id IN ('2000f9x0vqr8')
    and ec.reg_Internal_Code <> 'DF' -- Default
    --and seeds.seed_type = 'INTERNAL'
--order by seeds.seed_cont_id, comm.name, ec.reg_Internal_Code
GO

--select * from DMC_SEED_VIEW
/*=======================================================================================================================
Create Temporary Tables for Output and Deduping
=======================================================================================================================*/
if object_id('TempDB..##DMC_Seeds') is not null drop table ##DMC_Seeds
go

select *
into   ##DMC_Seeds
from   DMC_SEED_VIEW sv
--where  comm.Communication_Id IN ('2000f9x0vqr8')
--where  [user.CustomAttribute.COMM_CODE] IN ('EYP000003','EYP000011','EYP000016','EYP000024')
go

/*For collateral that are the same for each seg, delete all but one to avoid dupes in the seed file*/
--delete from ##DMC_Seeds
--where [user.customattribute.collatnm] IN ('EYPLEA_DSR_Program_Introduction', 'EYLEA_DSR_Program_Introduction-Ordered')
--  and [user.customattribute.segname] <> 'ACQUISITION A'
--go
  

/*=======================================================================================================================
Check for Duplicates
=======================================================================================================================*/
select * 
from  ##DMC_Seeds
where  [user.Email] in (SELECT [user.Email] from ##DMC_Seeds group by [user.Email] having count(1) > 1)

select *
from  ##DMC_Seeds a
where  cast(a.[user.CustomAttribute.Cont_Id] as varchar) + [user.CustomAttribute.COMM_CODE] in 
  (SELECT cast([user.CustomAttribute.Cont_Id] as varchar) + [user.CustomAttribute.COMM_CODE] 
   from ##DMC_Seeds 
   group by cast([user.CustomAttribute.Cont_Id] as varchar) + [user.CustomAttribute.COMM_CODE] having count(1) > 1
   )
order  by 1


/*=======================================================================================================================
Check all Collateral included
=======================================================================================================================*/
select [user.CustomAttribute.CommName], [user.CustomAttribute.CollatNm], [user.CustomAttribute.COMM_CODE], COUNT(DISTINCT [user.CustomAttribute.Cont_Id]) Unique_Seeds, COUNT(1) Total_Seeds
from  ##DMC_Seeds a
group by [user.CustomAttribute.CommName], [user.CustomAttribute.CollatNm], [user.CustomAttribute.COMM_CODE]
order by [user.CustomAttribute.CommName], [user.CustomAttribute.COMM_CODE]

/*=======================================================================================================================
For File Extracts
=======================================================================================================================*/
--CLIENT_DESCRIPTION_@YYYY@MM@DD
select *
from   ##DMC_Seeds
