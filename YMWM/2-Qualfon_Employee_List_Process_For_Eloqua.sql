/*=========================================================================================================
Generate Eloqua Qualfon_Employee_List
=========================================================================================================*/
/*
select top 5* from [dbo].[Qualfon_Stage_Employee_List_From_Footprint];
select top 5* from [dbo].[Qualfon_Stage_ADP_Temporary_Employee_List_From_HR]
select top 5* from [dbo].[Qualfon_Manual_Employee_List_Inclusions]

select count(1), count([Former Employee Id]) from [dbo].[Qualfon_Stage_Employee_List_From_Footprint];

select max([HR File Date]) from [Qualfon_Employee_List]

select [HR File Date], [Source], count(1) Quantity
from Qualfon_Employee_List_Historical
where [HR File Date] >= getdate() - 180
group by [HR File Date], [Source]
order by [HR File Date] desc, [Source];
*/

/*=========================================================================================================
Generate Eloqua Qualfon_Employee_List
 --Populate [Qualfon_Employee_List_Historical]
 --Truncate Stage Tables
=========================================================================================================*/

/*=========================================================================================================
Insert Group 1 and Group 3 employees from Employee Footprint Data 
=========================================================================================================*/
--TRUNCATE TABLE [Qualfon_Employee_List];
--go

INSERT INTO [dbo].[Qualfon_Employee_List]
           ([Source]
           ,[Employee ID]
           ,[Former Employee Id]
           ,[First Name]
           ,[Last Name]
           ,[Email Address]
           ,[Business Unit]
           ,[Managing Unit]
           ,[Functional Area]
           ,[Work Location]
           ,[Job Title]
           ,[Service Line]
           ,[Reporting Location]
           ,[Sub Department]
           ,[Country]
           ,[Supervisor Employee ID]
           ,[Supervisor First Name]
           ,[Supervisor Last Name]
           ,[Hire Date]
           ,[Remote Employee]
           ,[Email Source]
           ,[Original Email Address]
           ,[State of Residence])
select  [Source] = 'QNECT_EMPLOYEE_LIST'   
      , [Employee ID]
      , [Former Employee ID]
      , [First Name] = dbo.fn_capitalize(ltrim(rtrim([Employee First Name])))
      , [Last Name] = dbo.fn_capitalize(ltrim(rtrim([Employee Last Name])))
      , [Email Address] =case when [EmailAddress] = '' then null else [EmailAddress] end
      , [Business Unit]
      , [Managing Unit Name]
      , [Functional Area]
      , [Location] as [Work Location]
      , [Job Title]
      , [Service Line]
      , [Reporting Location]
      , [Sub Department]
      , [Country]
      , [Supervisor Employee ID] = case when [Supervisor Employee ID] = -1 then NULL else [Supervisor Employee ID] end 
      , [Supervisor First Name] = case when [Supervisor First Name] <> '**UNAVAILABLE' then NULL else [Supervisor First Name] end
      , [Supervisor Last Name] = case when [Supervisor Last Name] <> '**UNAVAILABLE' then NULL else [Supervisor Last Name] end
      , [Hire Date]
      , [RemoteEmployee]
      , [Email Source] = 'QNECT'
      , [Original Email Address] = case when [EmailAddress] = '' then null else [EmailAddress] end   
      , [State of Residence]
from [Qualfon_Stage_QNect_Employee_List] a
where not exists (select 1 from [Qualfon_Employee_List] b where a.[Employee ID] = b.[Employee ID]);
go

/*=========================================================================================================
Temporary:  Convert format of Qnect employee ID
=========================================================================================================*/
update Qualfon_Stage_ADP_Temporary_Employee_List_From_HR
set [QNect Employee Id] = cast([Qnect EID] as int)
where [Qnect EID] <> '';


/*=========================================================================================================
Insert Group 4 employees from HR Employee File 
=========================================================================================================*/
INSERT INTO [dbo].[Qualfon_Employee_List]
           ([Source]
           ,[Employee ID]
           ,[First Name]
           ,[Last Name]
           ,[Email Address]
           ,[Work Location]
           ,[Job Title]
           ,[Service Line]
           ,[Reporting Location]
           ,[Business Unit]
           ,[Managing Unit]
           ,[Country]
           ,[Supervisor First Name]
           ,[Supervisor Last Name]
           ,[Hire Date]
           ,[Regular/Temp]
           ,[Full-Time/Part-Time]
           ,[Hourly/Salary]
           ,[Staffing Agency Name]
           ,[Pay Group]
           ,[Email Source]
           ,[Original Email Address]
           ,[Temp Flag]
           ,[Exclude from YMWM]
           ,[Sub Department])
select [Source] = 'ADP' 
     , [Employee Id]
     , [First Name]
     , [Last Name]
     , [Email Address] = case when [Work Email] = '' then null else [Work Email] end 
     , [Work Location] = [Location Desc] 
     , [Job Title]
     , [Service Line] = [Department Name] 
     , [Reporting Location] =
       case 
         when [Location Desc] like '%Highland Park%' then 'US - HIGHLAND PARK (MS)' 
         when [Location Desc] like '%Robbinsville%' or [Location Desc] = 'New Jersey Remote Worker' then 'US - ROBBINSVILLE'
         when [Location Desc] like '%North Las Vegas%' then 'US - N LAS VEGAS'
       end 
     , [Business Unit] = 'MARKETING SERVICES'
     , [Managing Unit] = 'MANAGING UNIT 09 (ROBERT MASON)'
     , [Country] = case when [Location Desc] = 'Costa Rica' then 'Costa Rica' else 'United States' end
     , [Supervisor First Name] = [Manager Full Name]
     , [Supervisor Last Name] = [Manager Last Name]
     , [Hire Date] = [Last Hire Dt]
     , [Regular/Temp]
     , [Full-Time/Part-Time]
     , [Hourly/Salary] = [H/S]
     , [Staffing Agency Name]
     , [Pay Group]
     , [Email Source] = 'ADP' 
     , [Original Email Address] = case when [Work Email] = '' then null else [Work Email] end
     , [Temp Flag] = case when [Pay Group] in ('@BU','@BE') or [Regular/Temp] = 'T' then 'Y' else 'N' end
     , [Exclude from YMWM] = case when [Location Desc] LIKE '%Highland Park%' and a.[Last Hire Dt] >= getdate() - 27 then 1 else 0 end
     , [Sub Department] = [Payroll dept name]
from [Qualfon_Stage_ADP_Temporary_Employee_List_From_HR] a
where not exists (select 1 from [Qualfon_Employee_List] b where a.[Employee Id] = b.[Employee Id] or a.[Employee Id] = b.[Former Employee Id] or a.[QNect Employee Id] = b.[Employee ID])
  /*Temporary Pay Groups: Robbinsville (@BE) & HP/Vegas = @BU*/
  AND [Pay Group] IN ('@BE','@BU')
  /*Exclude Day Temps - No name entered into HR system*/
  AND [First Name] + [Last Name] not like '%temp%rbv%'
  AND [First Name] + [Last Name] not like '%bcs%temp%'
  /*Exclude employees who have a tenure less than 3 months*/
  AND datediff(mm,[Last Hire Dt],getdate()) >= 3 
  /*Exclude qualfon employees entered into ADP for financial/billing purposes. These employees are in QNect list*/
  AND isNULL([Staffing Agency Name],'') not in ('Qualfon employee','Netlink')
  /*Exclude IT Temporary employees*/
  AND [Department Name] <> 'IT';
go


/*=========================================================================================================
Forced Manual Inclusions - Employees who are not in QNect, but asked to be included by Mission Office
=========================================================================================================*/
INSERT INTO [dbo].[Qualfon_Employee_List]
           ([Source]
           ,[Employee ID]
           ,[First Name]
           ,[Last Name]
           ,[Email Address]
           ,[Employee Category]
           ,[Reporting Location]
           ,[Business Unit]
           ,[Managing Unit]
           ,[Job Title]
           ,[Country]
           ,[Email Source]
           ,[Has Direct Reports]
           ,[Exclude from YMWM]
           ,[Exclude from PO Survey])
select [Source]
      ,[Employee ID]
      ,[First Name]
      ,[Last Name]
      ,[Email Address]
      ,[Employee Category]
      ,[Reporting Location]
      ,[Business Unit]
      ,[Managing Unit]
      ,[Job Title]
      ,[Country]
      ,'MANUAL LIST' as [Email Source]
      ,[Has Direct Reports]
      ,case when [Include in YMWM] = 'N' then 1 else 0 end [Exclude from YMWM]
      ,case when [Include in PO Survey] = 'N' then 1 else 0 end [Exclude from PO Survey]
from [dbo].[Qualfon_Manual_Employee_List_Inclusions] a
where not exists (select 1 from [Qualfon_Employee_List] b where a.[Employee Id] = b.[Employee Id])
and a.[Active Flag] = 'Y';

/*=========================================================================================================
Has Direct Reports
=========================================================================================================*/
Update [Qualfon_Employee_List]
set [Has Direct Reports] = case when s.[Supervisor Employee ID] is not null then 'Y' else 'N' end
from Qualfon_Employee_List e
left join (SELECT [Supervisor Employee ID] from Qualfon_Employee_List GROUP BY [Supervisor Employee ID]) s on e.[Employee ID] = s.[Supervisor Employee ID]
where [Email Source] <> 'MANUAL LIST';

/*=========================================================================================================
Update Employee Category / List 
=========================================================================================================*/
/*Special temporary rules for MS, INS, IS*/
update [dbo].[Qualfon_Employee_List]
set [Employee Category] = 
      case 
         when [Temp Flag] = 'Y'
           then 'Temporary'
         when [Job Title] like '%SUPERVISOR%'
           or [Job Title] in ('LEAD, OPERATIONS'
                                ,'LEAD, PROJECT'
                                ,'SOT Team Lead Quality'
							                  ,'SOT Team Leader Call Center'
							                  ,'Team Lead Fulfillment'
                                ,'Costa Rica Team Lead Call Ctr'
                                ---NEW
                                ,'TEAM LEAD, FULFILLMENT'
                                ,'TEAM LEAD, CALL CENTER SOT'
                                )
           then 'Supervisor'
         when [Job Title] like '%AGENT%' 
           or [Job Title] in ( 'ANALYST, CUSTOMER SOLUTIONS'
                              ,'ANALYST, OPERATIONS, COMPLIANCE'
                              ,'ANALYST, QUALITY'
                              ,'ANALYST, REAL TIME'
                              ,'ASSOCIATE, ELITE CONCIERGE'
                              ,'ASSOCIATE, TRAVEL, II'
                              ,'ASSISTANT, QUALITY ASSURANCE'
                              )                              
           or [Job Title] like 'Customer Service Advocate%'
           or [Job Title] like 'Sr Customer Service Advocate%'
           or [Job Title] like 'ADVOCATE%'
           --New
           or [Job Title] like 'ACCOUNT, LIAISON%'
           or ([Job Title] Like 'TECHNICIAN, SUPPORT%' and isNULL([Functional Area],'') <> 'INFORMATION TECHNOLOGY')
           then 'Agent'
        --New Operational Staff to be added to Temporary/Operational Staff category
         when  [Job Title] like 'OPERATOR%'
            or [Job Title] like 'HANDLER%'
            or [Job Title] like 'CLERK, MAIL%'
            or [Job Title] like 'SPECIALIST, FULFILLMENT%'
            or [Job Title] like 'ORDER FULFILLMENT%'
            or [Job Title] like 'SPECIALIST, ASSEMBLY%'
            or [Job Title] like 'SPECIALIST, INVENTORY%'
            or [Job Title] like 'TRUCK, DRIVER%'
            or [Job Title] like 'GROUP LEAD, FULFILLMENT%'
            then 'Temporary'
         else 'Management'
      end
where [Employee Category] is null
  and [Business Unit] in ('INTEGRATED SOLUTIONS','INSURANCE','MARKETING SERVICES');

/*New assignment rules after corporate hierarchy changes -- will eventually be the same rules for IS, MS & INS*/
update [dbo].[Qualfon_Employee_List]
set [Employee Category] = 
      case 
         when [Temp Flag] = 'Y'
           then 'Temporary'
         when [Functional Area] = 'ASSOCIATES' 
           then 'Agent'
         when [Functional Area] = 'SUPERVISORS' 
           then 'Supervisor'
        --New Operational Staff to be added to Temporary/Operational Staff category
         when  [Job Title] like 'OPERATOR%'
            or [Job Title] like 'HANDLER%'
            or [Job Title] like 'CLERK, MAIL%'
            or [Job Title] like 'SPECIALIST, FULFILLMENT%'
            or [Job Title] like 'ORDER FULFILLMENT%'
            or [Job Title] like 'SPECIALIST, ASSEMBLY%'
            or [Job Title] like 'SPECIALIST, INVENTORY%'
            or [Job Title] like 'TRUCK, DRIVER%'
            or [Job Title] like 'GROUP LEAD, FULFILLMENT%'
            then 'Temporary'
         else 'Management'
      end
where [Employee Category] is null;


/*=========================================================================================================
Manual Email Overrides 
=========================================================================================================*/
/*Manual Email Address Updates*/
update Qualfon_Employee_List
set [Email Address] = b.[Email Address]
   ,[YMWM Valid Email] = 1
   ,[Email Update Comment] = case 
                               when a.[Email Address] is null  
                                 then 'Manually Append Email Address'
                                 else 'Manual Email Address Update'
                              end
   ,[Email Source] = 'MANUAL OVERRIDE'
from Qualfon_Employee_List a
join Qualfon_Employee_List_Manual_Email_Updates b on a.[Employee ID] = b.[Employee ID] or (a.[Former Employee Id] = b.[Employee ID])
where isnull(a.[Email Address],'X') <> b.[Email Address]
  and b.[Active Flag] = 'Y';


/*=========================================================================================================
Update domain & account name
=========================================================================================================*/
update [Qualfon_Employee_List] 
set Domain = RIGHT([Email Address], LEN([Email Address]) - CHARINDEX('@', [Email Address]))
where Domain is null
   or [Email Update Comment] is not null;

update [Qualfon_Employee_List] 
set [Email Account Name] = LEFT([Email Address], CHARINDEX('@', [Email Address]) - 1) 
where [Email Address] like '%@%';

 
/*=========================================================================================================
Suppress non DD/Qualfon/Kramer or Dupe Email Addresses 
=========================================================================================================*/
/*Non Work Emails*/
update [Qualfon_Employee_List]
set [YMWM Valid Email] = 0
   ,[Email Update Comment] = case when [Email Update Comment] is not null then [Email Update Comment] + '; Non Work Email' else 'Non Work Email' end
where [Source] <> 'MANUAL'
  and [Email Address] not like '%@%qualfon.com' 
  and [Email Address] not like '%@dialog-direct.com' 
  and [Email Address] not like '%@kramerdirect.com'
  and [Email Address] not like '%@wauk-dialog-direct.slack.com'
  and [Email Address] not like '%@ehealth.com'
  and [Email Address] not like '%@ehealthinsurance.com'
  and [Email Address] not like '%@assuredchoice.com';

/*Invalid Syntax*/
update [Qualfon_Employee_List]
set [YMWM Valid Email] = 0
   ,[Email Update Comment] = case when [Email Update Comment] is not null then [Email Update Comment] + '; Invalid Email Syntax' else 'Invalid Email Syntax' end
where [Email Address] like '%[^a-z,0-9,@,.,!,#,$,%%,&,'',*,+,--,/,=,?,^,_,`,{,|,},~]%' --First Carat ^ means Not these characters in the LIKE clause. The list is the valid email characters.
        OR [Email Address] NOT like '%_@_%_.[a-z,0-9][a-z]%'
        OR [Email Address] like '%@%@%'  
        OR [Email Address] like '%..%'
        OR [Email Address] like '.%'
        OR [Email Address] like '%.'
        OR [Email Address] like '% %';

/*Duplicate Emails*/
update [Qualfon_Employee_List]
set [YMWM Valid Email] = 0
   ,[Duplicate] = 'EMAIL_DUP'
   ,[Email Update Comment] = case when [Email Update Comment] is not null then [Email Update Comment] + '; Duplicate Email Address' else 'Duplicate Email Address' end
where [Email Address] in (select [Email Address] 
                          from [Qualfon_Employee_List] 
                          where [Email Address] is not null 
                            and [YMWM Valid Email] = 1 
                          group by [Email Address] 
                          having count(1) > 1);

update [Qualfon_Employee_List]
set [YMWM Valid Email] = 0
where [Email Address] is null;


/*=========================================================================================================
Assign a fake email address for those that do not have one and need to take Warehouse survey
   - When no email is provided
   - Marked as Duplicate
   - Marked as Exclude
   - Or Email marked as invalid 
=========================================================================================================*/
update Qualfon_Employee_List
set [Email Address] = cast([Employee ID] as varchar(30)) + '@fake.qualfon.invalid'
   ,[Email Update Comment] = case when [Email Update Comment] is not null then [Email Update Comment] + '; Assign fake email for Eloqua' else 'Assign fake email for Eloqua' end
   ,[YMWM Valid Email] = 0
where [Email Address] is null
   or [YMWM Valid Email] = 0
   or Duplicate is not null;   

/*=========================================================================================================
Assign YMWM Agent Link (B-13100)
  This field tells Eloqua to send the Agents the Eloqua survey link instead of the Agent link
=========================================================================================================*/
/* Agents receiving Eloqua Link */
update Qualfon_Employee_List
set [YMWM_Agent_Link] = 'ELOQUA_LINK'
where [Employee Category] = 'Agent'
  and isnull([YMWM_Agent_Link],'') <> 'ELOQUA_LINK'
  and [Reporting Location] like '%WAUKESHA%';

update Qualfon_Employee_List
set [YMWM_Agent_Link] = b.[YMWM_Agent_Link]
from Qualfon_Employee_List a 
join Qualfon_Agents_Requiring_Survey_Link b on a.[Employee ID] = b.[Employee ID] or (a.[Former Employee Id] = b.[Employee ID])
where isnull(a.[YMWM_Agent_Link],'X') <> b.[YMWM_Agent_Link];



/*=========================================================================================================
Assign YMWM Location & Managing Unit (B-27427)
  This was requested by Ariadna in the Mission Office to support their participation rate calculations 
  while the survey window is open. 

  B-28125 - REquested Assignment Changes
=========================================================================================================*/
UPDATE Qualfon_Employee_List
set [YMWM Location] = 
    case 
	    when [Business Unit] = 'CORPORATE' and [Reporting Location] not like '%CUATRO CIENEGAS%'
		    then 'CORP REMOTE STAFF'
		  when [Managing Unit] = 'MANAGING UNIT 04 (JASON LANCASTER)'
		    then 'CES SUPPORT DEPARTMENTS'
      when [Reporting Location] IN ('PHL - DUMAGUETE 2','PHL - DUMAGUETE 3')  
	        then 'PHL - DUMAGUETE' 
      when [Reporting Location] IN ('CUATRO CIENEGAS 2040','CUATRO CIENEGAS ISJ')
        then 'CUATRO CIENEGAS'
      when [Reporting Location] IN ('GUYANA','GY - GEORGETOWN 1') 
        then 'GY - GEORGETOWN'
      when [Reporting Location] = 'MEXICO'
        then 'MX - MEXICO CITY'
      when [Reporting Location] = 'COSTA RICA'
        then 'CRI - HEREDIA'
		else [Reporting Location]
    end

update Qualfon_Employee_List
set [YMWM Managing Unit] = 
    case 
      when [YMWM Location] = 'CORP REMOTE STAFF'
           and [Managing Unit] IN ('CORPORATE OPERATIONS (DOUG KEARNEY)'
                                   ,'EXECUTIVE (MIKE MARROW)'
                                   ,'INVESTMENT'
                                   ,'LEGAL'
                                   ,'MERGERS AND ACQUISITIONS'
                                   ,'SALES & MARKETING')
        then 'SHARED SERVICES'
      else [Managing Unit]
    end


/*=========================================================================================================
                                             END PROCESSING
=========================================================================================================*/


/*=========================================================================================================
Validation Check - Review any marked as duplicates
=========================================================================================================*/
select [Original Email Address], *
from Qualfon_Employee_List
where Duplicate = 'EMAIL_DUP'
order by 1;
--should be zero


/*=========================================================================================================
Validation Check - Any record where Reporting Location or Managing Unit is NULL
=========================================================================================================*/
select [Email Source], [Reporting Location], [Managing Unit], [Work Location], count(1)
from Qualfon_Employee_List e
where isnull([Reporting Location],'') = ''
   or isnull([Managing Unit],'') = '' 
   or [Reporting Location] = 'COUNTRY'
group by [Email Source], [Reporting Location], [Managing Unit],[Work Location]
order by [Email Source], [Reporting Location], [Managing Unit],[Work Location];

select [Email Source], [Business Unit], [Reporting Location], [Managing Unit], [Work Location], count(1)
from Qualfon_Employee_List e
where [Temp Flag] = 'Y'
group by [Email Source], [Business Unit], [Reporting Location], [Managing Unit],[Work Location]
order by [Email Source], [Business Unit], [Reporting Location], [Managing Unit],[Work Location];

/*=========================================================================================================
Validation Check - Invalid Email Syntax
(373592 - to fix)
=========================================================================================================*/
/*Bad Email Addressses*/
--Spaces was submitted to Service Desk to correct, not yet completed.
select a.Source, a.[Employee ID], a.[Employee Category], a.[First Name], a.[Last Name], a.[Email Address], a.[Original Email Address], a.[Email Update Comment], a.[Reporting Location]
from Qualfon_Employee_List a
where [Original Email Address] like '%[^a-z,0-9,@,.,!,#,$,%%,&,'',*,+,--,/,=,?,^,_,`,{,|,},~]%' --First Carat ^ means Not these characters in the LIKE clause. The list is the valid email characters.
        OR [Original Email Address] NOT like '%_@_%_.[a-z,0-9][a-z]%'
        OR [Original Email Address] like '%@%@%'  
        OR [Original Email Address] like '%..%'
        OR [Original Email Address] like '.%'
        OR [Original Email Address] like '%.'
        OR [Original Email Address] like '% %'
        OR [Email Update Comment] like '%Invalid Email Syntax%';

/*=========================================================================================================
Compare Headcounts to Previous List - Investigate any high number differences
=========================================================================================================*/
if object_id('tempdb..##CurrentList') is not null drop table ##CurrentList;
go

select [Source], [Employee ID], [First Name], [Last Name], [Reporting Location], [Employee Category]
into ##CurrentList
from Qualfon_Employee_List a
where [Duplicate] is null
  and [Exclude from YMWM] = 0;

if object_id('tempdb..##PreviousList') is not null drop table ##PreviousList;
go

select [Source], [Employee ID], [First Name], [Last Name], [Reporting Location], [Employee Category], [HR File Date]
into ##PreviousList
from Qualfon_Employee_List_Historical
where [Duplicate] is null
  and [Exclude from YMWM] = 0
  and [HR File Date] = (select max([HR File Date]) from Qualfon_Employee_List_Historical);

select  isnull(a.[Head Count],0) - isnull(b.[Head Count],0) Diff_Prev_Month
      , coalesce(a.[Reporting Location],b.[Reporting Location]) [Reporting Location]
      , coalesce(a.[Employee Category],b.[Employee Category]) [Employee Category]
      , isnull(a.[Head Count],0) as [Curr Head Count]
      , isnull(b.[Head Count],0) as [Prev Head Count]
from (select [Reporting Location], [Employee Category], count(1) [Head Count]
      from ##CurrentList a
      group by [Reporting Location], [Employee Category] 
      ) a
full outer join ( select [Reporting Location], [Employee Category], count(1) [Head Count]
                  from ##PreviousList
                  group by [Reporting Location], [Employee Category]
                 ) b on a.[Reporting Location] = b.[Reporting Location] and a.[Employee Category] = b.[Employee Category]
order by ABS(isnull(a.[Head Count],0) - isnull(b.[Head Count],0)) desc;
--order by coalesce(a.[Reporting Location],b.[Reporting Location]), coalesce(a.[Employee Category],b.[Employee Category])


/*=========================================================================================================
Were there any new locations or pay groups added to the ADP HR file that were not expected?
=========================================================================================================*/
select [Location Desc], [Pay Group], count(1)
from [Qualfon_Stage_ADP_Temporary_Employee_List_From_HR] a
where  [Regular/Temp] = 'T'
  AND [Pay Group] NOT IN ('@BE','@BU')
group by [Location Desc], [Pay Group];


/*=========================================================================================================
Review invalid non-work Emails
=========================================================================================================*/
select [Email Update Comment], count(1)
from [Qualfon_Employee_List]
where [Email Update Comment] is not null
group by [Email Update Comment];

select [Source], [Original Email Address], Domain, [Email Address], [Employee Id]
from [Qualfon_Employee_List]
where [Email Update Comment] like '%Non Work Email%';

select a.[Source], a.[Original Email Address], a.Domain, a.[Email Address], a.[Employee Id], b.*
from [Qualfon_Employee_List] a
left join Qualfon_Employee_List_Manual_Email_Updates b on a.[Employee ID] = b.[Employee ID] or (a.[Former Employee Id] = b.[Employee ID])
where [Email Update Comment] like '%Manual Email Address Update%';


/*=========================================================================================================
Query for Exporting List back to Eloqua 

Export to csv file (double quote qualified)
Qualfon_YMWM_MMDD_Employee_List_YYYYMMDD - First date is that of survey launch, second is file create date

When uploading to Eloqua
 - All fields should map automatically as they are named the same in the file as in Eloqua
 - YOU MUST UNIQUELY MATCH ON EMPLOYEE ID NOT EMAIL ADDRESS

Investigate any rejected records or duplicate email addresses if there are any.
=========================================================================================================*/
SELECT [Source] [Employee Source]
      ,[Employee ID]
      ,[Former Employee Id]
      ,[First Name]
      ,[Last Name]
      ,[Email Address]
      ,[Employee Category]
      ,[Business Unit]      
      ,[Reporting Location]
      ,[Managing Unit]
      ,[Functional Area]
      ,[Service Line]
      ,[Sub Department]
      ,[Job Title]
      ,[Work Location]
      ,[Country]
      ,[YMWM_Agent_Link]
      ,[HR File Date] as [Employee Footprint Date]
      ,[Email Source]
      ,[Temp Flag] as [Temporary Employee Flag]
      ,[Hire Date]
      ,[Has Direct Reports]
      ,[Exclude from YMWM] as [Exclude from YMWM Ind]
      ,[Exclude from PO Survey] as [Exclude from PO Survey Ind]
      ,[YMWM Location]
      ,[YMWM Managing Unit]
      ,[State of Residence] as [State or Province]
  FROM [dbo].[Qualfon_Employee_List]
where  [Duplicate] is null;


/*=========================================================================================================
Head Counts by Location
=========================================================================================================*/
select [YMWM Location]
     , [Business Unit]
     , [YMWM Managing Unit]
     , CASE [Employee Category]
         WHEN 'Management' then 'Management & Staff'
         WHEN 'Temporary' then 'Temporary & Operational Staff'
         ELSE [Employee Category]
       END [Employee Category]
     , count(1) [Head Count]
from Qualfon_Employee_List
where [Duplicate] is null
  and [Exclude from YMWM] = 0
group by [YMWM Location]
     , [Business Unit]
     , [YMWM Managing Unit]
     , CASE [Employee Category]
         WHEN 'Management' then 'Management & Staff'
         WHEN 'Temporary' then 'Temporary & Operational Staff'
         ELSE [Employee Category]
       END
order by [YMWM Location]
     , [Business Unit]
     , [YMWM Managing Unit]
     , CASE [Employee Category]
         WHEN 'Management' then 'Management & Staff'
         WHEN 'Temporary' then 'Temporary & Operational Staff'
         ELSE [Employee Category]
       END;

/*Export full list for Mission Office Review*/
SELECT [Source] [Employee Source]
      ,[Employee ID]
      ,[Former Employee Id]
      ,[First Name]
      ,[Last Name]
      ,case when [Email Address] like '%@%fake%' then '' else [Email Address] end [Email Address]
      ,[Email Source]
      ,CASE 
         WHEN [Employee Category] = 'Management' then 'Management & Staff'
         WHEN [Employee Category] = 'Temporary' then 'Temporary & Operational Staff'
         ELSE [Employee Category]
       END as [Employee Category]
      ,[YMWM Location]
      ,[YMWM Managing Unit]
      ,[Reporting Location]
      ,[Managing Unit]
      ,[Business Unit]
      ,[Functional Area]
      ,[Service Line]
      ,[Sub Department]
      ,[Job Title]
      ,[Work Location]
      ,[Country]
      ,[Temp Flag]
      ,[Hire Date]
      ,[Full-Time/Part-Time]
      ,[Hourly/Salary]
      ,[Staffing Agency Name]
      ,[Pay Group]
  FROM [dbo].[Qualfon_Employee_List] 
where  [Duplicate] is null
  and  [Exclude from YMWM] = 0
order by [Source], [Reporting Location], [Managing Unit], [Employee Category], [First Name], [Last Name];


/*=========================================================================================================
END
=========================================================================================================*/


