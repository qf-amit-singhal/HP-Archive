USE CIM_[APPCODE]_OUTPUT_STAGE_DB
GO

--IF OBJECT_ID('TEMP_ELANCO_PRODUCT_LIST') IS NOT NULL DROP TABLE TEMP_ELANCO_PRODUCT_LIST
--GO

--CREATE TABLE TEMP_ELANCO_PRODUCT_LIST (
--  PROD_ID           int IDENTITY(1,1),
--  PRODUCT           varchar(30),
--  TRADEMARK         varchar(30),
--  ESTABLISHED_NAME  varchar(50),
--  ACC_NAME          varchar(30)
--)
--GO

      
--INSERT INTO TEMP_ELANCO_PRODUCT_LIST (PRODUCT,TRADEMARK,ESTABLISHED_NAME,ACC_NAME)
--VALUES 
--('Cheristin for cats', 'Cheristin', 'Cheristin® for cats (spinetoram)', 'CHERISTIN'),
--('Comfortis', 'Comfortis', 'Comfortis® (spinosad)', 'COMFORTIS'),
--('EasySpot for Cats', 'EasySpot', 'EasySpot® for Cats (fipronil)', 'EASYSPOT'),
--('Interceptor Flavor Tabs', 'Interceptor Flavor Tabs', 'Interceptor® (milbemycin oxime) Flavor Tabs®  ', 'INTERCEPTOR'),
--('Interceptor Plus', 'Interceptor', 'Interceptor® Plus (milbemycin oxime/praziquantel)', 'INTERCEPTOR_PLUS'),
--('Parastar for dogs', 'Parastar', 'Parastar® for dogs (fipronil)', 'PARASTAR'),
--('Parastar Plus for dogs', 'Parastar', 'Parastar® Plus for dogs (fipronil/cyphenothrin)', 'PARASTAR_PLUS'),
--('Trifexis', 'Trifexis', 'Trifexis® (spinosad + milbemycin oxime)', 'TRIFEXIS')
--GO
      

--select ACC_NAME, PRODUCT, ESTABLISHED_NAME, TRADEMARK from TEMP_ELANCO_PRODUCT_LIST


--IF OBJECT_ID('DMC_SEED_LIST') IS NOT NULL DROP TABLE DMC_SEED_LIST
--GO

--CREATE TABLE DMC_SEED_LIST (
--  SEED_CONT_ID  int IDENTITY(1,1),
--  FIRST_NAME    varchar(30),
--  LAST_NAME     varchar(30),
--  EMAIL_ADDRESS varchar(255),
--  SEED_TYPE     varchar(255),
--  PET_NAME      varchar(30)
--)
--GO

--ALTER TABLE DMC_SEED_LIST ADD CONSTRAINT DMC_SEED_LIST__SEEDTYPE_CK
--    CHECK (SEED_TYPE IN ('INTERNAL','EXTERNAL'))
--GO

    
--TRUNCATE TABLE DMC_SEED_LIST

IF OBJECT_ID('TempDB..#Seeds') IS NOT NULL DROP TABLE #Seeds
GO

SELECT FIRST_NAME, LAST_NAME, EMAIL_ADDRESS, SEED_TYPE, PET_NAME
INTO   #Seeds
FROM   DMC_SEED_LIST
WHERE  1 = 2
GO

INSERT INTO #Seeds (FIRST_NAME, LAST_NAME, EMAIL_ADDRESS, SEED_TYPE, PET_NAME) 
  VALUES ('Angela', 'Plafcan', 'angela.plafcan@dialog-direct.com', 'INTERNAL', 'NO NAME')
       , ('Rowena', 'Gumayan', 'Rowena.Gumayan@dialog-direct.com', 'INTERNAL', 'SPOT')
       , ('Andrew', 'Brubaker','Andrew.Brubaker@dialog-direct.com', 'INTERNAL', 'NO NAME')
       , ('', 'Brubaker','Andrew.Brubaker@dialog-direct.com', 'INTERNAL', 'SPOT')
       , ('ShivaKumar', 'Pocha','ShivaKumar.Pocha@dialog-direct.com', 'INTERNAL', 'SPOT')
       
       
       --, ('Angela', 'Plafcan', 'plafcan21@test', 'INTERNAL', 'SPOT')
       --, ('Angela', 'Plafcan', 'plafcan21@yahoo.com', 'INTERNAL', 'SPOT')
       --, ('Andrew', 'Brubaker','andrew.e.brubaker@ml.com', 'INTERNAL', 'SPOT')
       --, ('Alyse', 'Moss', 'Alyse.Moss@dialog-direct.com', 'INTERNAL', 'SPOT')
       --, ('Ben', 'Chiappetta', 'Benjamin.Chiappetta@dialog-direct.com', 'INTERNAL', 'SPOT')
       --, ('Ben', 'Chiappetta', 'Benjamin.Chiappetta@dialog-direct.com', 'INTERNAL', 'SPOT')
       --, ('Layla', 'Goodwin', 'Layla.Goodwin@dialog-direct.com', 'INTERNAL', 'SPOT')     
       --, ('Alyse', 'Moss', 'alyse.moss@gmail.com', 'INTERNAL', 'NO NAME')
       --, ('Alyse', 'Moss', 'alyse.solomon@gmail.com', 'INTERNAL', 'SPOT')  
       --, ('Angela', 'Plafcan', 'plafcan21@gmail.com', 'INTERNAL', 'SPOT')
       --, ('Angela', 'Plafcan', 'plafcan21@hotmail.com', 'INTERNAL', 'SPOT')       
       --, ('Andrew', 'Brubaker','brubandy@verizon.net', 'INTERNAL', 'SPOT')
       --, ('Andrew', 'Brubaker','brubandy@yahoo.com', 'INTERNAL', 'SPOT')
       --, ('Andrew', 'Brubaker','brubandy@gmail.com', 'INTERNAL', 'SPOT')
       --, ('Andrew', 'Brubaker','brubandy@hotmail.com', 'INTERNAL', 'SPOT')       
       --, ('Andrew', 'Brubaker','andrew.brubaker@dialog-direct.biz', 'INTERNAL', 'SPOT')
       --, ('Rowena', 'Gumayan', 'rigemployment@yahoo.com', 'INTERNAL', 'SPOT')

       
       /*External Emails*/
       --, ('Shermika', 'Duerson', 'sduerson@elanco.com ', 'EXTERNAL', 'SPOT')
       --, ('Diana', 'Trautmann', 'trautmann_diana@elanco.com ', 'EXTERNAL', 'SPOT')
       --, ('Leigh ', 'Young-Hill', 'leigh.young-hill@elanco.com ', 'EXTERNAL', 'SPOT')
       --, ('genefer', 'douglass','douglass_genefer_l@elanco.comm', 'EXTERNAL', 'SPOT')
       --, ('melissa', 'reeve','reeve_melissa@network.elanco.com', 'EXTERNAL', 'SPOT')
       --, ('Brandi', 'Frye','ElancoTestEmails@callahancreek.com ', 'EXTERNAL', 'SPOT')



GO

/*INSERT NEW*/
INSERT INTO DMC_SEED_LIST (FIRST_NAME, LAST_NAME, EMAIL_ADDRESS, SEED_TYPE, PET_NAME) 
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

/*Create Seed View*/
if object_id('DMC_Seed_View') is not null drop view DMC_Seed_View
go

create view DMC_Seed_View as 
select distinct
       cast(seed_cont_id as varchar) + '_' + ec.eah_Internal_Code + '_' + log_seg.Logical_Segment_Id + '_' + replace(replace(replace(replace(convert(varchar(20),getdate(),121),' ',''),'.',''),'-',''),':','') + '@regseed.dialogdirect.com' [user.Email]
      ,seeds.email_address as [user.customAttribute.alternateEmail]
      ,'ELANCO' [user.CustomAttribute.Client]
      ,ec.eah_coll_account [user.CustomAttribute.ACC_Name]
      ,null as [user.CustomAttribute.HOUSEHOLD_ID]
      ,seeds.seed_cont_id * -1 as [user.CustomAttribute.Cont_Id] --force to not match to db
      ,seeds.seed_cont_id * -1 as [user.CustomAttribute.ACCT_CONT_ID] --force to not match to db
      ,null as [user.CustomAttribute.Lead_Key_Id]
      ,log_seg.Logical_Segment_Id as [user.CustomAttribute.Leaf_Segment_Id] -- seeds won't have a leaf_segment_id
      ,pkg_collat.Collateral_Id as [user.CustomAttribute.Collateral_Id]
      ,comm.Communication_Id as [user.CustomAttribute.Communication_Id]
      ,step.Step_Id as [user.CustomAttribute.Step_Id]
      ,comm.name as [user.CustomAttribute.CommName]
      ,collat.name as [user.CustomAttribute.CollatNm]
      ,seg.name as [user.CustomAttribute.SegName]
      ,ec.eah_Internal_Code as [user.CustomAttribute.COMM_CODE]
      ,null as [user.CustomAttribute.Subject]
      ,convert(varchar(10),getdate(),120) as [user.CustomAttribute.CommDate]
      ,seeds.first_name as [user.FirstName]
      ,seeds.last_name as [user.LastName]
      ,seeds.PET_NAME as [user.CustomAttribute.Pet_Name]
      ,p.PRODUCT as [user.CustomAttribute.Product_Name]
      ,p.ESTABLISHED_NAME as [user.CustomAttribute.Product_Full_Name]
      ,p.TRADEMARK as [user.CustomAttribute.Product_Name2]      
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
join TEMP_ELANCO_PRODUCT_LIST p on p.acc_name = ec.eah_coll_account
cross join DMC_SEED_LIST seeds
where  comm.Communication_Id IN ('2000fvq83lts' --Refill Reminder
                                ,'2000fvq839g7' --Dosage Reminder                                 
                                 )
  and  seg.name NOT IN ('Email','SMS')
  and  ec.eah_vendor_code <> 'Waterfall'
go



--select * from DMC_Seed_View


/*=======================================================================================================================
Create Temporary Tables for Output and Deduping
=======================================================================================================================*/
if object_id('TempDB..##DMC_Seeds') is not null drop table ##DMC_Seeds
go

select *
into   ##DMC_Seeds
from   DMC_SEED_VIEW sv
go

/*For collateral that are the same for each seg, delete all but one to avoid dupes in the seed file*/
--delete from ##DMC_Seeds
--where 
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
--ELANCO_CRM_REFILL_REMINDER_@RUN_@YYYY@MM@DD.csv
select *
from   ##DMC_Seeds
--where  [user.CustomAttribute.Communication_Id] = '2000fvq83lts'
--and    [user.CustomAttribute.ACC_Name] = 'EASYSPOT'                        
                                
--ELANCO_CRM_DOSAGE_REMINDER_@RUN_@YYYY@MM@DD.csv
select *
from   ##DMC_Seeds
--where  [user.CustomAttribute.Communication_Id] = '2000fvq839g7'