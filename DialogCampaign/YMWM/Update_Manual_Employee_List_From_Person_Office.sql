/*===========================================================================================
View Records in Staged File
--TRUNCATE TABLE [Qualfon_Stage_Manual_Empoyee_List]
===========================================================================================*/

SELECT [Source]
      ,[First Name]
      ,[Last Name]
      ,[Email Address]
      ,[Employee Category]
      ,[Reporting Location]
      ,[Business Unit]
      ,[Managing Unit]
      ,[Job Title]
      ,[Country]
      ,[Has Direct Reports]
      ,[Include in YMWM]
      ,[Include in PO Survey]
      ,[Status]
      ,[Date Modified]
  FROM [Qualfon_Stage_Manual_Empoyee_List]

/*===========================================================================================
View Records in Staged File
===========================================================================================*/
select count(1), count(distinct [Email Address])
from [Qualfon_Stage_Manual_Empoyee_List];
--should be no duplicate email addressses

--Any with status of null, should already exist in the manual table
select a.*, b.*
from [Qualfon_Stage_Manual_Empoyee_List] a
left join [Qualfon_Manual_Employee_List_Inclusions] b on a.[Email Address] = b.[Email Address]
where [Status] is null
  and b.[Email Address] is null
--should be 0

--View any with status of remove
select b.[Active Flag], a.*
from [Qualfon_Stage_Manual_Empoyee_List] a
left join [Qualfon_Manual_Employee_List_Inclusions] b on a.[Email Address] = b.[Email Address]
where [Status] = 'REMOVE'

--All records in stage table that are not in the production table should have a status of Add*/
select a.*
from [Qualfon_Stage_Manual_Empoyee_List] a
left join [Qualfon_Manual_Employee_List_Inclusions] b on a.[Email Address] = b.[Email Address]
where b.[Email Address] is null

--There should be no active records in the production table that aren't in the stage table: If any confirm with Person Office*/
select b.*
from [Qualfon_Manual_Employee_List_Inclusions] b
left join [Qualfon_Stage_Manual_Empoyee_List] a on a.[Email Address] = b.[Email Address]
where a.[Email Address] is null
  and b.[Active Flag] = 'Y'

--View any with status of Add
select a.*
from [Qualfon_Stage_Manual_Empoyee_List] a
where [Status] = 'Add'

/*===========================================================================================
Mark those with status of remove as inactive
===========================================================================================*/
update [Qualfon_Manual_Employee_List_Inclusions]
set [Active Flag] = 'N'
from [Qualfon_Manual_Employee_List_Inclusions] b
join [Qualfon_Stage_Manual_Empoyee_List] a on a.[Email Address] = b.[Email Address]
where a.[Status] = 'REMOVE'
  and  [Active Flag] = 'Y'
--1

/*===========================================================================================
Were any "active" employees updated?
===========================================================================================*/
select a.*, b.*
from [Qualfon_Manual_Employee_List_Inclusions] a
join [Qualfon_Stage_Manual_Empoyee_List] b on a.[Email Address] = b.[Email Address] and a.[Active Flag] = 'Y'
where 1=1 and (
   isnull(a.[Employee Category],'') <> isnull(b.[Employee Category],'')
   or isnull(a.[Business Unit],'') <> isnull(b.[Business Unit],'')
   or isnull(a.[Managing Unit],'') <> isnull(b.[Managing Unit],'')
   or isnull(a.[Reporting Location],'') <> isnull(b.[Reporting Location],'')
   or isnull(a.[Has Direct Reports],'') <> case when b.[Has Direct Reports] = 'NO' then 'N' when b.[Has Direct Reports] = 'YES' then 'Y' else '' end 
   or isnull(a.[Include in YMWM],'') <> case when b.[Include in YMWM] = 'NO' then 'N' when b.[Include in YMWM] = 'YES' then 'Y' else '' end 
   or isnull(a.[Include in PO Survey],'') <> case when b.[Include in PO Survey] = 'NO' then 'N' when b.[Include in PO Survey] = 'YES' then 'Y' else '' end 
);

update [Qualfon_Manual_Employee_List_Inclusions]
set [Employee Category]    = b.[Employee Category]
   ,[Business Unit]        = b.[Business Unit]
   ,[Managing Unit]        = b.[Managing Unit]
   ,[Reporting Location]   = b.[Reporting Location]
   ,[Has Direct Reports]   = case when b.[Has Direct Reports] = 'NO' then 'N' when b.[Has Direct Reports] = 'YES' then 'Y' else '' end 
   ,[Include in YMWM]      = case when b.[Include in YMWM] = 'NO' then 'N' when b.[Include in YMWM] = 'YES' then 'Y' else '' end 
   ,[Include in PO Survey] = case when b.[Include in PO Survey] = 'NO' then 'N' when b.[Include in PO Survey] = 'YES' then 'Y' else '' end 
from [Qualfon_Manual_Employee_List_Inclusions] a
join [Qualfon_Stage_Manual_Empoyee_List] b on a.[Email Address] = b.[Email Address] and a.[Active Flag] = 'Y'
where isnull(a.[Employee Category],'') <> isnull(b.[Employee Category],'')
   or isnull(a.[Business Unit],'') <> isnull(b.[Business Unit],'')
   or isnull(a.[Managing Unit],'') <> isnull(b.[Managing Unit],'')
   or isnull(a.[Reporting Location],'') <> isnull(b.[Reporting Location],'')
   or isnull(a.[Has Direct Reports],'') <> case when b.[Has Direct Reports] = 'NO' then 'N' when b.[Has Direct Reports] = 'YES' then 'Y' else '' end 
   or isnull(a.[Include in YMWM],'') <> case when b.[Include in YMWM] = 'NO' then 'N' when b.[Include in YMWM] = 'YES' then 'Y' else '' end 
   or isnull(a.[Include in PO Survey],'') <> case when b.[Include in PO Survey] = 'NO' then 'N' when b.[Include in PO Survey] = 'YES' then 'Y' else '' end ;



/*===========================================================================================
Add those with status of Add
===========================================================================================*/
INSERT INTO [dbo].[Qualfon_Manual_Employee_List_Inclusions]
           ([Source]
           ,[First Name]
           ,[Last Name]
           ,[Email Address]
           ,[Employee Category]
           ,[Reporting Location]
           ,[Business Unit]
           ,[Managing Unit]
           ,[Job Title]
           ,[Country]
           ,[Has Direct Reports]
           ,[Include in YMWM]
           ,[Include in PO Survey]
           ,[Active Flag])
SELECT
   [Source]
  ,[First Name]
  ,[Last Name]
  ,[Email Address]
  ,[Employee Category]
  ,[Reporting Location]
  ,[Business Unit]
  ,[Managing Unit]
  ,[Job Title]
  ,[Country]  
  ,case [Has direct reports] when 'YES' then 'Y' when 'Y' then 'Y' else 'N' END
  ,case [Include in YMWM] when 'YES' then 'Y' when 'Y' then 'Y' else 'N' END as [Include in YMWM]
  ,case [Include in PO Survey] when 'YES' then 'Y' when 'Y' then 'Y' else 'N' END as [Include in PO Survey]
  ,'Y' as [Active Flag]  
  FROM [Qualfon_Stage_Manual_Empoyee_List]
  Where [Status] = 'Add'
    and [Email Address] not in (select [Email Address] from [Qualfon_Manual_Employee_List_Inclusions]);

select * 
from [Qualfon_Manual_Employee_List_Inclusions]
where [Date Added] = cast(getdate() as DATE)
