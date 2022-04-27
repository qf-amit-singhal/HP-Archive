use cim_views_db
go 

if object_id('cim_communications_with_leads_vw') is not null drop view cim_communications_with_leads_vw
go 

create view cim_communications_with_leads_vw as (
select case when mds.name like 'EAH%' then 'Elanco'
            when mds.name like 'HAP%' then 'HAP'
            when mds.name like 'HMCMDR%' then 'Honda'
            when mds.name like 'REG%' then 'Regeneron'
            when mds.name like 'TEVA%' then 'TEVA'
            else mds.name
       end client,
       mds.name customer_schema_name, c.communication_id, c.name comm_nm, 
       c.actual_communication_start_dt, c.actual_communication_end_dt,
       coalesce(teva_comm_type, reg_comm_type, eah_comm_type, hap_comm_type, hmc_comm_type) comm_type,
       dd.description comm_type_descr
from   cim_meta_db.dbo.cm_communication c
join   cim_meta_db.dbo.md_schema mds on c.schema_id = mds.schema_id
left join cim_meta_db.dbo.ex_communication  excomm on c.communication_id = excomm.communication_id
left join (select distinct description, database_cd 
           from cim_meta_db.dbo.dd_cm_drop_down where category like '%Comm_Type'
           ) dd on dd.database_cd = coalesce(teva_comm_type, reg_comm_type, eah_comm_type, hap_comm_type, hmc_comm_type)
where  exists ( /*Teva*/
                select 1
                from   cim_teva_leads_db.dbo.lh_lead_key_history ch_teva
                where  ch_teva.communication_id = c.communication_id
                  and  ch_teva.communication_id <> '1000f0ml8cfz'  --HCP Lead Injector
                union all                 
                /*Elanco*/
                select 1
                from   cim_eahmdr_leads_db.dbo.LH_LEAD_KEY_HISTORY ch_eahmdr
                where  ch_eahmdr.communication_id = c.communication_id
                  and  ch_eahmdr.communication_id <> '1000fx90pkm9' --Pre-Deployment Functionality Test
                union all
                /*Elanco*/
                select 1
                from   cim_regmdr_leads_db.dbo.lh_lead_key_history ch_regmdr
                where  ch_regmdr.communication_id = c.communication_id
                union all
                /*HAP*/
                select 1
                from   cim_hapmdr_leads_db.dbo.lh_lead_key_history ch_hapmdr
                where  ch_hapmdr.communication_id = c.communication_id
                union all
                /*Honda*/
                select 1
                from   cim_hmcmdr_leads_db.dbo.lh_lead_key_history ch_hmcmdr
                where  ch_hmcmdr.communication_id = c.communication_id
                union all
                /*Signal*/
                select 1
                from   cim_sfcumdr_leads_db.dbo.lh_lead_key_history ch_sfcumdr
                where  ch_sfcumdr.communication_id = c.communication_id
               )
)


