begin
  execute immediate 'drop materialized view tmp_eloqua_contact_mv';
exception
 when others then
  null;
end;
/


create materialized view tmp_eloqua_contact_mv
 refresh complete
 as

select  c.cont_id
      , ct.ct_code contact_type
      , c.cont_parent_id
      , c.cont_prefix
      , initcap(c.cont_first_name) cont_first_name
      , initcap(c.cont_middle_name) cont_middle_name
      , cont_last_name
      , c.cont_suffix
      , c.cont_gender
      , to_char(c.cont_dob, 'MM/DD/YYYY') cont_dob
      , cont_email
      , regexp_replace(dsms.dsms_security.decrypt_val(c.cont_email, 'EAHMDR'),'^.*@([^\.]+)\.com','\1') cont_email_domain
      , c.cont_active_flag
      , c.cont_valid_email_flag
      , c.cont_invalid_email_reason_code
      , cch.cch_type as preferred_channel
      , to_char(c.cont_create_date,'MM/DD/YYYY HH:MI:SS') cont_create_date
      , to_char(c.cont_update_date,'MM/DD/YYYY HH:MI:SS') cont_update_date
      , ca_id
      , ca_address_1
      , ca_address_2
      , ca_city
      , ca_state
      , ca_zip
      , ca_zip4
      , ca_country
      , ca_addr_active_flag
      , ca_valid_mail_flag
      , cont_mobile
      , cont_phone
      , cont_valid_mobile_flag
      , s.Mosaic_Segment
      , s.Mosaic_Group
      , s.Mosaic_Score_Date
      , case when pref.cont_id is not null then 'Y' else 'N' end as Pref_Center_Act_Exists
      , to_char(pref.wa_acc_create_date,'MM/DD/YYYY') as Pref_Center_Act_Create_Dt
      , to_char( pref.wa_last_activity_date,'MM/DD/YYYY') as Pref_Center_Last_Activity_Dt
      , email.capref_flag as Elanco_Email_Opt
      , sms.capref_flag as Elanco_SMS_Opt
      , dm.capref_flag as Elanco_DM_Opt
      , row_number() Over(Partition By c.cont_email order by c.cont_id) email_rank
from  eahmdr.contact c
join  eahmdr_cim_da.tmp_eloqua_contact_sample e on c.cont_id = e.cont_id 
join  eahmdr.contact_type ct on c.ct_id = ct.ct_id
left join eahmdr.communication_channel cch on c.cont_preferred_cch_id = cch.cch_id
left join eahmdr.contact_address ca on c.cont_id = ca.cont_id
left join (select wa.cont_id, min(wa.wa_acc_create_date) wa_acc_create_date, max(wal.wal_create_date) wa_last_activity_date
           from   eahmdr.web_account wa
           left join eahmdr.web_access_log wal on wa.wa_id = wal.wa_id and wal_logon_success_flag = 'Y'
           where  wa.cont_id is not null
           group by wa.cont_id
          ) pref on c.cont_id = pref.cont_id
left join eahmdr_cim_da.tmp_eloqua_pref_mv email on c.cont_id = email.cont_id and email.cch_type = 'EMAIL' and email.pt_code = 'ELANCO'
left join eahmdr_cim_da.tmp_eloqua_pref_mv sms on c.cont_id = sms.cont_id and sms.cch_type = 'SMS' and sms.pt_code = 'ELANCO'
left join eahmdr_cim_da.tmp_eloqua_pref_mv dm on c.cont_id = dm.cont_id and dm.cch_type = 'DIRECT MAIL' and dm.pt_code = 'ELANCO'
left join (select cont_id
                , cms_segment as Mosaic_Segment
                , cms_group as Mosaic_Group
                , to_char(trunc(cms.cms_update_date), 'MM/DD/YYYY') Mosaic_Score_Date
           from   eahmdr.cont_model_score cms
           join   eahmdr.scoring_model sm on cms.sm_id = sm.sm_id
           where  sm_model_name = 'MOSAIC'
          ) s on s.cont_id = c.cont_id;

grant select on tmp_eloqua_contact_mv to aplafcan, bchiappetta, eahmdr_select_role, eahmdr_dm_user, eahmdr_cim_da;

select count(1), count(distinct cont_id) from tmp_eloqua_contact_mv;
--1  104307  104307

create index TMP_CONTMV_IDX1 on tmp_eloqua_contact_mv(cont_id);
create index TMP_CONTMV_IDX2 on tmp_eloqua_contact_mv(email_rank);

grant select on tmp_eloqua_contact_mv to aplafcan, bchiappetta, eahmdr_select_role, eahmdr_cim_role, eahmdr_dm_user;
grant select on tmp_eloqua_contact_mv to eahmdr_cim_views with grant option;


