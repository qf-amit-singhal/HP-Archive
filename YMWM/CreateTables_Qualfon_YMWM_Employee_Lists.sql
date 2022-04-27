/*==================================================================================================
Stage table for employee footprint
==================================================================================================*/
--if object_id('Qualfon_Stage_QNect_Employee_List') is not null drop table [Qualfon_Stage_QNect_Employee_List]
--go
CREATE TABLE [dbo].[Qualfon_Stage_QNect_Employee_List](
  [Supervisor Employee ID] [int] NULL,
  [Supervisor First Name] [varchar](100) NULL,
  [Supervisor Last Name] [varchar](100) NULL,
  [Employee ID] [int] NULL,
  [Employee First Name] [varchar](100) NULL,
  [Employee Last Name] [varchar](100) NULL,
  [EmailAddress] [nvarchar](255) NULL,
  [Business Unit] [varchar](100) NULL,
  [Managing Unit Name] [varchar](100) NULL, 
  [Functional Area] [nvarchar](100) NULL,
  [Country] [nvarchar](255) NULL,  
  [Reporting Location] [nvarchar](255) NULL,
  [Location] [nvarchar](255) NULL, 
  [Service Line] [nvarchar](255) NULL,
  [Job Title] [nvarchar](255) NULL,
  [Original Hire Date] [datetime] NULL,
  [Hire Date] [datetime] NULL,
  [Seniority Date] [datetime] NULL,
  [Tenure] [nvarchar](255) NULL,
  [Birthday] [nvarchar](10) NULL,
  [Anniversary] [nvarchar](10) NULL,
  [RemoteEmployee] [nvarchar](10) NULL,
  [State of Residence] [nvarchar](10) NULL,
  [Sub Department] [nvarchar](255) NULL,  
  [Former Employee ID] int NULL,
  [Date Created] DATE default getdate()
) ON [PRIMARY];
GO

/*==================================================================================================
Stage table for temporary employee file from ADP
==================================================================================================*/
--if object_id('Qualfon_Stage_ADP_Temporary_Employee_List_From_HR') is not null drop table [Qualfon_Stage_ADP_Temporary_Employee_List_From_HR]
--go

CREATE TABLE [dbo].[Qualfon_Stage_ADP_Temporary_Employee_List_From_HR](
	[Employee Id] [int] NULL,
  [Qnect EID] [nvarchar](255) NULL,
  [QNect Employee Id] int NULL,
  [First Name] [nvarchar](255) NULL,
	[Last Name] [nvarchar](255) NULL,
	[Department Name] [nvarchar](255) NULL,
	[Payroll Dept Name] [nvarchar](255) NULL,
  [Job Title] [nvarchar](255) NULL,
	[Location Desc] [nvarchar](255) NULL,
  [Reporting Location] [nvarchar](255) NULL,
  [Work Email] [nvarchar](255) NULL,
	[Personal Email] [nvarchar](255) NULL,
  [Last Hire Dt] date NULL,
  [Regular/Temp] [nvarchar](255) NULL,
  [Full-Time/Part-Time] [nvarchar](255) NULL,
  [Manager Last Name] [nvarchar](255) NULL,
  [Manager Full Name] [nvarchar](255) NULL,
  [H/S] [nvarchar](255) NULL,
  [Staffing Agency Name] [nvarchar](255) NULL,
  [Pay Group] [nvarchar](255) NULL,
  [Date Created] DATE default getdate()
) ON [PRIMARY];
GO

/*==================================================================================================
Final table for current employee list, processed from stage tables.
==================================================================================================*/
--if object_id('Qualfon_Employee_List') is not null drop table Qualfon_Employee_List
--go

create table Qualfon_Employee_List (
  [Source] varchar(30),
  [Employee ID] int,
  [Former Employee Id] int,
  [First Name] varchar(100),
  [Last Name] varchar(100),
  [Email Address] varchar(100),
  [Employee Category] varchar(30),
  [Business Unit] varchar(100),
  [Managing Unit] [varchar](100) NULL,
  [Functional Area] [nvarchar](100) NULL,
  [Work Location] varchar(100),
  [Job Title] varchar(100),
  [Service Line] varchar(100),
  [Sub Department] [nvarchar](255) NULL,
  [Reporting Location] varchar(100),
  [Country] varchar(30),
  [State of Residence] varchar(30) NULL,
  [Supervisor Employee ID] int,
  [Supervisor First Name] varchar(100),
  [Supervisor Last Name] varchar(100),
  [Hire Date] date NULL,
  [Remote Employee] [nvarchar](10) NULL,
  [Regular/Temp] [nvarchar](255) NULL,
  [Full-Time/Part-Time] [nvarchar](255) NULL,
  [Hourly/Salary] [nvarchar](255) NULL,
  [Staffing Agency Name] [nvarchar](255) NULL,
  [Pay Group] [nvarchar](255) NULL,
  [Email Source] varchar(100) NULL,
  [Original Email Address] varchar(100),
  [Email Update Comment] varchar(255),
  [Domain] varchar(100),
  [Email Account Name] varchar(100),
  [Has Direct Reports] varchar(1) default 'N' CONSTRAINT QEL_HDR CHECK([Has Direct Reports] in ('N','Y')),
  [YMWM Valid Email] int default 1 CONSTRAINT QEL_ValidEmail CHECK([YMWM Valid Email] in (0,1)),
  [Duplicate] varchar(30) CONSTRAINT QEL_Duplicate CHECK(Duplicate in ('EMAIL_DUP','QNECT_ADP_DUP','NO_LONGER_EMPLOYED','QNECT_ADP_DUP','QNECT_DUPLICATE')),
  [Temp Flag] varchar(1) default 'N' CONSTRAINT QEL_TempFlag CHECK([Temp Flag] in ('N','Y')),
  [Exclude from YMWM] int default 0 CONSTRAINT QEL_Exclude CHECK([Exclude from YMWM] in (0,1)),
  [Exclude from PO Survey] int default 0 CONSTRAINT QEL_ExcludePersonOfficeSurvey CHECK([Exclude from PO Survey] in (0,1)),
  [YMWM_Agent_Link] varchar(30),
  [YMWM Location] varchar(100),
  [YMWM Managing Unit] [varchar](100) NULL,
  [HR File Date]  date DEFAULT GETDATE()
  CONSTRAINT QEL_EmployeeID UNIQUE ([Employee ID])
);
go

/*==================================================================================================
Historical employee list - post corporate structure changes. 
==================================================================================================*/
create table Qualfon_Employee_List_Historical (
[Source] varchar(30),
[Employee ID] int,
[Former Employee Id] int,
[Employee] varchar(100),
[First Name] varchar(100),
[Last Name] varchar(100),
[Email Address] varchar(100),
[Employee Category] varchar(30),
[Business Unit] varchar(100),
[Managing Unit] [varchar](100) NULL,
[Functional Area] [nvarchar](100) NULL,
[Work Location] varchar(100),
[Job Title] varchar(100),
[Service Line] varchar(100),
[Reporting Location] varchar(100),
[Country] varchar(30),
[Supervisor] varchar(100),
[Supervisor Employee ID] int,
[Supervisor First Name] varchar(100),
[Supervisor Last Name] varchar(100),
[Hire Date] date NULL,
[Remote Employee] varchar(10) NULL,
[Regular/Temp] [nvarchar](255) NULL,
[Full-Time/Part-Time] [nvarchar](255) NULL,
[Hourly/Salary] [nvarchar](255) NULL,
[Staffing Agency Name] [nvarchar](255) NULL,
[Pay Group] [nvarchar](255) NULL,
[Email Source] varchar(100) NULL,
[Original Email Address] varchar(100),
[Email Update Comment] varchar(255),
[Domain] varchar(100),
[Email Account Name] varchar(100),
[Has Direct Reports] varchar(1) NULL,
[YMWM Valid Email] int default 1,
[Duplicate] varchar(30),
[Temp Flag] varchar(1),
[Exclude from YMWM] int,
[Exclude from PO Survey] int NULL,
[YMWM_Agent_Link] varchar(30),
[HR File Date]  date DEFAULT GETDATE(),
[Date Created]  date DEFAULT GETDATE(),
[Sub Department] [nvarchar](255) NULL,
[YMWM Location] varchar(100),
[YMWM Managing Unit] [varchar](100) NULL,
[State of Residence] [varchar](30) NULL,
CONSTRAINT QELH_Employee_ID_Date UNIQUE ([Employee ID],[HR File Date])
);
go


/*==================================================================================================
Stage table for Manual Employee List (employees who do not exist in QNect)
==================================================================================================*/
--if object_id('Qualfon_Stage_Manual_Empoyee_List') is not null drop table [Qualfon_Stage_Manual_Empoyee_List]
--go
CREATE TABLE [dbo].[Qualfon_Stage_Manual_Empoyee_List](
	[Source] [nvarchar](10) NULL,
	[First Name] [nvarchar](100) NULL,
	[Last Name] [nvarchar](100) NULL,
	[Email Address] [nvarchar](100) NULL,
	[Employee Category] [nvarchar](30) NULL,
	[Reporting Location] [nvarchar](100) NULL,
	[Business Unit] [nvarchar](30) NULL,
  [Managing Unit] [nvarchar](30) NULL,
	[Job Title] [nvarchar](100) NULL,
  [Country] [nvarchar](30) NULL,
	[Has Direct Reports] [nvarchar](5) NULL,
	[Include in YMWM] [nvarchar](5) NULL,
	[Include in PO Survey] [nvarchar](5) NULL,
	[Status] [nvarchar](30) NULL,
  [Date Modified] datetime NULL
) ON [PRIMARY]
GO



/*==================================================================================================
Table to store all employees requested to be manually included in the list
==================================================================================================*/
create table Qualfon_Manual_Employee_List_Inclusions (
[Source] varchar(10) default 'MANUAL',
[Employee ID] int identity(999999000,1),
[First Name] varchar(100),
[Last Name] varchar(100),
[Email Address] varchar(100),
[Employee Category] varchar(30),
[Reporting Location] varchar(100),
[Business Unit] varchar(100),
[Managing Unit] varchar(100),
[Job Title] varchar(100),
[Country] varchar(30),
[Has Direct Reports] varchar(1) CONSTRAINT QMELI_DirectReports CHECK([Has Direct Reports] in ('N','Y')),
[Include in YMWM] varchar(1) CONSTRAINT QMELI_YMWMFlag CHECK([Include in YMWM] in ('N','Y')),
[Include in PO Survey] varchar(1) CONSTRAINT QMELI_POFlag CHECK([Include in PO Survey] in ('N','Y')),
[Active Flag] varchar(1) default 'Y' CONSTRAINT QMELI_ActiveFlag CHECK([Active Flag] in ('N','Y')),
[Date Added] date DEFAULT GETDATE()
CONSTRAINT QMELI_Employee_ID UNIQUE ([Employee ID]),
CONSTRAINT QMELI_Email UNIQUE ([Email Address]),
);
go


/*==================================================================================================
Process table for employees that need their email address manually overwritten
 - Requested by managers prior to QNect transition.
 - No longer accepting new requests.  New requests must be handled in HR system.
==================================================================================================*/
--if object_id('Qualfon_Employee_List_Manual_Email_Updates') is not null drop table Qualfon_Employee_List_Manual_Email_Updates
--go

create table Qualfon_Employee_List_Manual_Email_Updates(
[Employee ID] int,
[First Name] varchar(100),
[Last Name] varchar(100),
[Email Address] varchar(100),
[Date Created]  date DEFAULT GETDATE(),
[Active Flag] varchar(1) default 'Y' CONSTRAINT QELMU_ActiveFlag CHECK([Active Flag] in ('N','Y')),
CONSTRAINT QELMU_Employee_ID UNIQUE ([Employee ID]),
CONSTRAINT QELMU_Email UNIQUE ([Email Address]),
);
go

/*==================================================================================================
Process table for employees that specifically need to receive the Agent or Eloqua link outside
 of the normal rules.  This is needed when there are access issues that can't be resolved by IT.
==================================================================================================*/
--if object_id('Qualfon_Agents_Requiring_Survey_Link') is not null drop table Qualfon_Agents_Requiring_Survey_Link
--go
create table Qualfon_Agents_Requiring_Survey_Link(
[Employee ID] int NOT NULL,
[First Name] varchar(100),
[Last Name] varchar(100),
[YMWM_Agent_Link] varchar(30) CONSTRAINT QARSL_AgentLink CHECK([YMWM_Agent_Link] in ('AGENT_LINK','ELOQUA_LINK')),
[Date Created]  date DEFAULT GETDATE(),
[Active Flag] varchar(1) default 'Y' CONSTRAINT QARSL_ActiveFlag CHECK([Active Flag] in ('N','Y')),
CONSTRAINT QARSL_UNIQUE UNIQUE ([Employee ID])
);
go


/*==================================================================================================
Process table used to identify if there are any new values that would in turn require adjustments
  to Eloqua segments and/or pick lists. 
==================================================================================================*/
Create table Qualfon_Eloqua_Field_Values (
[Field Type] varchar(35),
[Field Value] varchar(100),
[Date Added] date DEFAULT GETDATE()
CONSTRAINT QEFV_Unique UNIQUE ([Field Type],[Field Value])
);
go
