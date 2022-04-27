create or replace view tmp_eloqua_contact_vw as 
select  cont_id
      , contact_type
      , cont_parent_id
      , cont_prefix
      , cont_first_name
      , cont_middle_name
      , initcap(dsms.dsms_security.decrypt_val(c.cont_last_name, 'EAHMDR')) as cont_last_name
      , cont_suffix
      , cont_gender
      , cont_dob
      , case when email_rank = 1 and cont_valid_email_flag = 'Y' then dsms.dsms_security.decrypt_val(c.cont_email, 'EAHMDR') else null end as cont_email
      , cont_active_flag
      , cont_valid_email_flag
      , cont_invalid_email_reason_code
      , preferred_channel
      , cont_create_date
      , cont_update_date
      , ca_id
      , initcap(dsms.dsms_security.decrypt_val(ca_address_1, 'EAHMDR')) as ca_address_1
      , initcap(dsms.dsms_security.decrypt_val(ca_address_2, 'EAHMDR')) as ca_address_2
      , initcap(dsms.dsms_security.decrypt_val(ca_city, 'EAHMDR')) as ca_city
      , dsms.dsms_security.decrypt_val(ca_state, 'EAHMDR') as ca_state
      , dsms.dsms_security.decrypt_val(ca_zip, 'EAHMDR') as ca_zip
      , dsms.dsms_security.decrypt_val(ca_zip4, 'EAHMDR') as ca_zip4
      , ca_country
      , ca_addr_active_flag
      , ca_valid_mail_flag
      , cont_mobile
      , cont_phone
      , cont_valid_mobile_flag
      , Mosaic_Segment
      , Mosaic_Group
      , Mosaic_Score_Date
      , Pref_Center_Act_Exists
      , Pref_Center_Act_Create_Dt
      , Pref_Center_Last_Activity_Dt
      , Elanco_Email_Opt
      , Elanco_SMS_Opt
      , Elanco_DM_Opt
      , Email_Rank
from  eahmdr_cim_da.tmp_eloqua_contact_mv c;

grant select on tmp_eloqua_contact_vw to aplafcan, bchiappetta, eahmdr_select_role, eahmdr_dm_user, eahmdr_cim_da;

select count(1), count(distinct cont_id) from tmp_eloqua_contact_vw;
--1	104307	104307

select Email_Rank, count(1), count(distinct cont_id) from tmp_eloqua_contact_vw where cont_email is not null group by Email_Rank;

select Num_Contacts, count(1)
from (
select cont_email, count(1) Num_Contacts
from   tmp_eloqua_contact_vw
where cont_email is not null
group by cont_email
) x
group by Num_Emails
/*
NUM_CONTACTS	COUNT(1)
1	92121
*/



