USE [ANALYTICS_FORD]
GO

-------------------------------------------------------------------------------------------------------
/* Create Table ELOQUA_API_EMAIL_ATTRIBUTES */
CREATE TABLE [dbo].[ELOQUA_API_EMAIL_ATTRIBUTES](
  [EAEA_id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [EmailRecipientId] [varchar](38) NOT NULL,
  [VIN] [varchar](17) NULL,
  [EAEA_Create_Date] DATETIME DEFAULT GETDATE()
);
	 
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-EmailRecipientID] ON [dbo].[ELOQUA_API_EMAIL_ATTRIBUTES]([EmailRecipientId] ASC);



-------------------------------------------------------------------------------------------------------
/* Create Table ELOQUA_API_EMAIL_BOUNCEBACK */

CREATE TABLE [dbo].[ELOQUA_API_EMAIL_BOUNCEBACK](
  [EAEB_id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [Activity_Id] [bigint] NOT NULL,
  [ActivityType] [varchar](100) NOT NULL,
  [ActivityDate] [datetime] NOT NULL,
  [EmailAddress] [varchar](400) NOT NULL,
  [EmailRecipientId] [varchar](38) NOT NULL,
  [ContactId] [int] NULL,
  [AssetType] [varchar](100) NULL,
  [AssetName] [varchar](100) NULL,
  [AssetId] [int] NULL,
  [CampaignId] [int] NULL,
  [CampaignName] [varchar](100) NULL,
  [ExternalId] [varchar](20) NULL,
  [DeploymentId] [int] NULL,
  [SmtpErrorCode] [varchar](9) NULL,
  [SmtpStatusCode] [varchar](3) NULL,
  [SmtpMessage] [varchar](510) NULL,  
  [EAEB_Create_Date] DATETIME DEFAULT GETDATE()
 );
 GO
 
CREATE NONCLUSTERED INDEX [NonClusteredIndex-EmailActivityDate] ON [dbo].[ELOQUA_API_EMAIL_BOUNCEBACK]([ActivityDate] ASC);

CREATE NONCLUSTERED INDEX [NonClusteredIndex-EmailRecipientID] ON [dbo].[ELOQUA_API_EMAIL_BOUNCEBACK]([EmailRecipientId] ASC);

CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-ActivityID] ON [dbo].[ELOQUA_API_EMAIL_BOUNCEBACK] ([Activity_ID] ASC);

-------------------------------------------------------------------------------------------------------
/*Create Table [ELOQUA_API_EMAIL_CLICKTHROUGH] */

CREATE TABLE [dbo].[ELOQUA_API_EMAIL_CLICKTHROUGH](
  [EAEC_id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [Activity_ID] [bigint] NOT NULL,
  [ActivityType] [varchar](100) NOT NULL,
  [ActivityDate] [datetime] NOT NULL,
  [EmailAddress] [varchar](400) NOT NULL,
  [EmailRecipientId] [varchar](38) NOT NULL,
  [ContactId] [int] NULL,
  [AssetId] [int] NULL,
  [AssetType] [varchar](100) NULL,
  [AssetName] [varchar](100) NULL,  
  [CampaignId] [int] NULL,  
  [CampaignName] [varchar](100) NULL,  
  [SubjectLine] [varchar](500) NULL,
  [EmailWebLink] [varchar](1000) NULL,
  [EmailClickedThruLink] [varchar](1000) NULL,
  [IpAddress] [varchar](50) NULL,
  [VisitorId] [int] NULL,
  [VisitorExternalId] [int] NULL,
  [ExternalId] [varchar](20) NULL,
  [DeploymentId] [varchar](100) NULL,
  [EmailSendType] [varchar](100) NULL,
  [CampaignResponseDate] [datetime] NULL,
  [CampaignResponseMemberStatus] [varchar](150) NULL,
  [EAEC_Create_Date] DATETIME DEFAULT GETDATE()
);
 
CREATE NONCLUSTERED INDEX [NonClusteredIndex_ActivityDate] ON [dbo].[ELOQUA_API_EMAIL_CLICKTHROUGH] ([ActivityDate] ASC);

CREATE NONCLUSTERED INDEX [NonClusteredIndex_EmailRecipientID] ON [dbo].[ELOQUA_API_EMAIL_CLICKTHROUGH] ([EmailRecipientId] ASC);

CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex_ActivityID] ON [dbo].[ELOQUA_API_EMAIL_CLICKTHROUGH] ([Activity_Id] ASC);


--------------------------------------------------------------------------------------------------------------------
---------CREATE TABLE ELOQUA_API_EMAIL_OPEN----------------------------------------

CREATE TABLE [dbo].[ELOQUA_API_EMAIL_OPEN](
  [EAEO_id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [Activity_Id] [bigint] NOT NULL,
  [ActivityType] [varchar](100) NOT NULL,
  [ActivityDate] [datetime] NOT NULL,
  [EmailAddress] [varchar](400) NOT NULL,
  [EmailRecipientId] [varchar](38) NOT NULL,
  [ContactId] [int] NULL,
  [AssetId] [int] NULL,
  [AssetType] [varchar](100) NULL,
  [AssetName] [varchar](100) NULL,
  [CampaignId] [int] NULL,
  [CampaignName] [varchar](100) NULL,
  [SubjectLine] [varchar](500) NULL,
  [EmailWebLink] [varchar](1000) NULL,  
  [IpAddress] [varchar](50) NULL,
  [VisitorId] [int] NULL,
  [VisitorExternalId] [int] NULL,
  [ExternalId] [varchar](20) NULL,
  [DeploymentId] [varchar](100) NULL,
  [EmailSendType] [varchar](100) NULL,
  [CampaignResponseDate] [datetime] NULL,
  [CampaignResponseMemberStatus] [varchar](150) NULL,  
  [EAEO_Create_Date] DATETIME DEFAULT GETDATE()
 );

CREATE NONCLUSTERED INDEX [NonClusteredIndex_EmailOpen_ActivityDate] ON [dbo].[ELOQUA_API_EMAIL_OPEN] ([ActivityDate] ASC);

CREATE NONCLUSTERED INDEX [NonClusteredIndex_EmailOpen_EmailRecipientID] ON [dbo].[ELOQUA_API_EMAIL_OPEN] ([EmailRecipientId] ASC);

CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex_EmailOpen_ACtivityID] ON [dbo].[ELOQUA_API_EMAIL_OPEN] ( [Activity_Id] ASC);


-----------------------Create Table ELOQUA_API_EMAILSEND----------------------------------

CREATE TABLE [dbo].[ELOQUA_API_EMAIL_SEND](
[EAES_id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
[Activity_Id] [bigint] NOT NULL,
[ActivityType] [varchar](100) NOT NULL,
[ActivityDate] [datetime] NOT NULL, 
[EmailAddress] [varchar](400) NULL,
[EmailRecipientId] [varchar](38) NOT NULL,
[ContactId] [int] NULL,
[AssetId] [int] NULL,
[AssetType] [varchar](100) NULL,
[AssetName] [varchar](100) NULL,
[CampaignId] [int] NULL,
[CampaignName] [varchar](100) NULL,
[SubjectLine] [varchar](500) NULL,
[EmailWebLink] [varchar](1000) NULL,
[ExternalId] [varchar](20) NULL,
[DeploymentId] [int] NULL,
[EmailSendType] [varchar](100) NULL,
[CampaignResponseDate] [datetime] NULL,
[CampaignResponseMemberStatus] [varchar](150) NULL,  
[EAES_Create_Date] DATETIME DEFAULT GETDATE()
);

CREATE NONCLUSTERED INDEX [NonClusteredIndex_ActivityDate] ON [dbo].[ELOQUA_API_EMAIL_SEND] ([ActivityDate] ASC);

CREATE NONCLUSTERED INDEX [NonClusteredIndex_EmailRecipientID] ON [dbo].[ELOQUA_API_EMAIL_SEND] ([EmailRecipientId] ASC);

CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex_ActivityID] ON [dbo].[ELOQUA_API_EMAIL_SEND] ([Activity_Id] ASC);



-----------------------Create Table ELOQUA_API_EMAIL_UNSUBSCRIBE----------------------------------
CREATE TABLE [dbo].[ELOQUA_API_EMAIL_UNSUBSCRIBE](
  [EAEU_id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [Activity_Id] [bigint] NOT NULL,
  [ActivityType] [varchar](100) NOT NULL,
  [ActivityDate] [datetime] NOT NULL,
  [EmailAddress] [varchar](400) NOT NULL,
  [EmailRecipientId] [varchar](38) NOT NULL,
  [ContactId] [int] NULL,
  [AssetId] [int] NULL,
  [AssetType] [varchar](100) NULL,
  [AssetName] [varchar](100) NULL,
  [CampaignId] [int] NULL,
  [CampaignName] [varchar](100) NULL,
  [ExternalId] [varchar](20) NULL,  
  [EAEU_Create_Date] DATETIME DEFAULT GETDATE()
);

CREATE NONCLUSTERED INDEX [NonClusteredIndex_EmailUnsub_ActivityDate] ON [dbo].[ELOQUA_API_EMAIL_UNSUBSCRIBE] ([ActivityDate] ASC);

CREATE NONCLUSTERED INDEX [NonClusteredIndex_EmailUnsub_EmailRecipientID] ON [dbo].[ELOQUA_API_EMAIL_UNSUBSCRIBE] ([EmailRecipientId] ASC);

CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex_EmailUnsub_ActivityID] ON [dbo].[ELOQUA_API_EMAIL_UNSUBSCRIBE] ([Activity_Id] ASC);


