/*=========================================================================================================
Populate Eloqua Field Values with any new values in the Reporting Location, Managing Unit or Business Unit
  fields.  Any new values to these fields could potentially require changes to Eloqua pick lists and/or 
  segments.
=========================================================================================================*/
insert into Qualfon_Eloqua_Field_Values([Field Type],[Field Value])
select distinct 'Reporting Location' as [Field Type], [Reporting Location] as [Field Value]
FROM [dbo].[Qualfon_Employee_List] a
where not exists (select 1
                  from Qualfon_Eloqua_Field_Values b 
                  where b.[Field Type] = 'Reporting Location'
                    and b.[Field Value] = a.[Reporting Location]
                  )
order by 1,2;

insert into Qualfon_Eloqua_Field_Values([Field Type],[Field Value])
select distinct 'Managing Unit' as [Field Type], [Managing Unit] as [Field Value]
FROM [dbo].[Qualfon_Employee_List] a
where not exists (select 1
                  from Qualfon_Eloqua_Field_Values b 
                  where b.[Field Type] = 'Managing Unit'
                    and b.[Field Value] = a.[Managing Unit]
                  )
order by 1,2;

insert into Qualfon_Eloqua_Field_Values([Field Type],[Field Value])
select distinct 'Business Unit' as [Field Type], [Business Unit] as [Field Value]
FROM [dbo].[Qualfon_Employee_List] a
where not exists (select 1
                  from Qualfon_Eloqua_Field_Values b 
                  where b.[Field Type] = 'Business Unit'
                    and b.[Field Value] = a.[Business Unit]
                  )
order by 1,2;

select *
from Qualfon_Eloqua_Field_Values
where cast([Date Added] as date) = cast(getdate() as date)
order by [Field Type],[Field Value]


/*=========================================================================================================
Populate Historical Employee List table.
=========================================================================================================*/
INSERT INTO [dbo].[Qualfon_Employee_List_Historical]
           ([Source]
           ,[Employee ID]
           ,[Former Employee Id]
           --,[Employee]
           ,[First Name]
           ,[Last Name]
           ,[Email Address]
           ,[Employee Category]
           ,[Business Unit]
           ,[Managing Unit]
           ,[Functional Area]
           ,[Work Location]
           ,[Job Title]
           ,[Service Line]
           ,[Reporting Location]
           ,[Country]
           --,[Supervisor]
           ,[Supervisor Employee ID]
           ,[Supervisor First Name]
           ,[Supervisor Last Name]
           ,[Hire Date]
           ,[Remote Employee]
           ,[Regular/Temp]
           ,[Full-Time/Part-Time]
           ,[Hourly/Salary]
           ,[Staffing Agency Name]
           ,[Pay Group]
           ,[Email Source]
           ,[Original Email Address]
           ,[Email Update Comment]
           ,[Domain]
           ,[Email Account Name]
           ,[Has Direct Reports]
           ,[YMWM Valid Email]
           ,[Duplicate]
           ,[Temp Flag]
           ,[Exclude from YMWM]
           ,[Exclude from PO Survey]
           ,[YMWM_Agent_Link]
           ,[HR File Date]
           ,[YMWM Location]
           ,[YMWM Managing Unit]
           ,[State of Residence])
select [Source]
      ,[Employee ID]
      ,[Former Employee Id]
      --,[Employee]
      ,[First Name]
      ,[Last Name]
      ,[Email Address]
      ,[Employee Category]
      ,[Business Unit]
      ,[Managing Unit]
      ,[Functional Area]
      ,[Work Location]
      ,[Job Title]
      ,[Service Line]
      ,[Reporting Location]
      ,[Country]
      --,[Supervisor]
      ,[Supervisor Employee ID]
      ,[Supervisor First Name]
      ,[Supervisor Last Name]
      ,[Hire Date]
      ,[Remote Employee]
      ,[Regular/Temp]
      ,[Full-Time/Part-Time]
      ,[Hourly/Salary]
      ,[Staffing Agency Name]
      ,[Pay Group]
      ,[Email Source]
      ,[Original Email Address]
      ,[Email Update Comment]
      ,[Domain]
      ,[Email Account Name]
      ,[Has Direct Reports]
      ,[YMWM Valid Email]
      ,[Duplicate]
      ,[Temp Flag]
      ,[Exclude from YMWM]
      ,[Exclude from PO Survey]
      ,[YMWM_Agent_Link]
      ,[HR File Date]
      ,[YMWM Location]
      ,[YMWM Managing Unit]
      ,[State of Residence]
From Qualfon_Employee_List a
where not exists (select 1
                  from [Qualfon_Employee_List_Historical] b 
                  where a.[Employee ID] = b.[Employee ID]
                    and a.[HR File Date] = b.[HR File Date]
                );
GO


SELECT COUNT(1) as CURR_COUNT FROM [Qualfon_Employee_List];

SELECT COUNT(1) as HIST_COUNT
FROM [Qualfon_Employee_List_Historical] a
JOIN [Qualfon_Employee_List] b on a.[Employee ID] = b.[Employee ID]
WHERE a.[HR File Date] = b.[HR File Date];


/*
DECLARE @CurrCt int 
      , @HistCt int 
SET @CurrCt = (SELECT COUNT(1) FROM [Qualfon_Employee_List])
SET @HistCt = (SELECT COUNT(1)
               FROM [Qualfon_Employee_List_Historical] a
               JOIN [Qualfon_Employee_List] b on a.[Employee ID] = b.[Employee ID]
               WHERE a.[HR File Date] = b.[HR File Date])

PRINT @CurrCt
PRINT @HistCt


IF (@CurrCt = @HistCt AND @HistCt > 0) 
BEGIN 
   TRUNCATE TABLE [Qualfon_Employee_List]
   PRINT 'Truncated Qualfon_Employee_List'
   TRUNCATE TABLE [dbo].[Qualfon_Stage_Employee_List_From_Footprint]
   PRINT 'Truncated Qualfon_Stage_Employee_List_From_Footprint'
   TRUNCATE TABLE [dbo].[Qualfon_Stage_ADP_Temporary_Employee_List_From_HR]
   PRINT 'Truncated Qualfon_Stage_ADP_Temporary_Employee_List_From_HR'
   --TRUNCATE TABLE [dbo].[Qualfon_Stage_Manual_Empoyee_List]
   --PRINT 'Truncated Qualfon_Stage_Manual_Empoyee_List'
END
*/

/*=========================================================================================================
END
=========================================================================================================*/