USE [Eloqua_Email_Activity]
GO

CREATE TABLE [dbo].[ELOQUA_API_EMAIL_ACTIVITY_STAGE](
  [EAS_Id] [int] IDENTITY(1,1) NOT NULL,  
  [ClientCode] VARCHAR(30) NOT NULL,
  [StatusCode] [varchar](100) NOT NULL DEFAULT 'LD_SUCCESS',
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
  [VisitorExternalId] [int] NULL,
  [SmtpErrorCode] [varchar](9) NULL,
  [SmtpStatusCode] [varchar](3) NULL,
  [SmtpMessage] [varchar](510) NULL,
  [IpAddress] [varchar](50) NULL,
  [VisitorId] [int] NULL,
  [ExternalId] [varchar](20) NULL,
  [DeploymentId] [varchar](100) NULL,
  [EmailSendType] [varchar](100) NULL,
  [CampaignResponseDate] [datetime] NULL,
  [CampaignResponseMemberStatus] [varchar](150) NULL,
  [VIN] [varchar](17) NULL,
  [EAS_CREATE_DATE] [datetime] NULL,
	
CONSTRAINT [PK_EMAILACTIVITY_STG] PRIMARY KEY CLUSTERED ([EAS_id] ASC) 
  WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY])
GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ELOQUA_API_EMAIL_ACTIVITY_STAGE] ADD  DEFAULT (getdate()) FOR [EAS_CREATE_DATE]
GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex_EAS_EmailRecipientID] ON [dbo].[ELOQUA_API_EMAIL_ACTIVITY_STAGE]([EmailRecipientId] ASC) 
  WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-EAS_ActivityID] ON [dbo].[ELOQUA_API_EMAIL_ACTIVITY_STAGE]([ACTIVITY_ID] ASC)
  WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex_EAS_EmailActivityDate] ON [dbo].[ELOQUA_API_EMAIL_ACTIVITY_STAGE] ([ActivityDate] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-------------------------------------------------------------------------------------------------------


