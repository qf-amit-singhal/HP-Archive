select 'CIM' [Application]
      , t.client [Client Name]
      , t.comm_nm [Campaign Name]
      , t.Actual_Communication_Start_Dt [Start Date]
      , t.Actual_Communication_End_Dt [End Date]
      , t.comm_type_descr [Type]
      , cch.Channel [Channel]
      , case when Actual_Communication_Start_Dt = Actual_Communication_End_Dt then 'Ad-hoc'
             when Actual_Communication_End_Dt is null then 'Recurring-Active'
             when Actual_Communication_Start_Dt < Actual_Communication_End_Dt then 'Recurring-Inactive'
        end [Adhoc/Recurring]
      , case when Actual_Communication_Start_Dt >= CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) as DATE) then 'Y' else 'N' end [New Last Month]
      , NULL as [Total Sends]
      , convert(varchar(10), getdate(), 101) [Run Date]
from cim_views_db.dbo.cim_communications_with_leads_vw t
left join ( select distinct a.communication_id, case when Channel_Cnt = 1 then cm_channel_class else 'Multi-Channel' end Channel
            from   cim_views_db.dbo.cim_comm_channel_class_vw a
            left join ( select communication_id, count(distinct cm_channel_class) Channel_Cnt
                        from   cim_views_db.dbo.cim_comm_channel_class_vw
                        group by communication_id
                       ) b on a.communication_id = b.communication_id
           ) cch on t.communication_id = cch.communication_id

union all

/*DMC Campaign Listing*/
select 'DMC' [Application]
     , case when group_category_name like 'Regeneron%' then 'Regeneron'
            when group_category_name like 'RGN%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
            else group_category_name
       end [Client Name]
     , message_name [Campaign Name]
     , convert(varchar(10),min(cast(sentToMTA_Timestamp as date)),112) [Start Date]
     , case when max(cast(sentToMTA_Timestamp as date)) >= getdate() -7 then null else convert(varchar(10),max(cast(sentToMTA_Timestamp as date)),112) end [End Date]
     , '' as [Type] --message_Category_Name may be able to be used in the future for this
     , 'Email' as [Channel]
     , case when datediff(dd,min(cast(sentToMTA_Timestamp as date)), max(cast(sentToMTA_Timestamp as date))) <= 5 then 'Ad-hoc' else 'Recurring' end [Adhoc/Recurring]     
     , case when min(cast(sentToMTA_Timestamp as date)) >= CAST(DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) as DATE) then 'Y' else 'N' end [New Last Month]    
     , count(1) [Total Sends]     
     , convert(varchar(10), getdate(), 101) [Run Date]
from  emailCampaigns_adhoc.dbo.RawDataExport_DMC_Metrics
where group_category_name <> 'Test_Group_Category'
group by case when group_category_name like 'regeneron%' then 'Regeneron'
            when group_category_name like 'RGN%' then 'Regeneron'
            when group_category_name like 'EAH%' then 'Elanco'
            when group_category_name like 'HAP%' then 'HAP'
            when group_category_name like 'TEVA%' then 'TEVA'
            when group_category_name like 'SAF%' then 'Safeco'
            when group_category_name like 'AZ%' then 'AstraZenica'
            else group_category_name
       end
         , group_category_name, message_name 
order by 1,2,3
       
       