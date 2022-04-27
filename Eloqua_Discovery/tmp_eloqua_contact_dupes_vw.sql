create or replace view tmp_eloqua_contact_dupes_vw as 
select  cont_id
      , contact_type
      , cont_first_name
      , cont_middle_name
      , initcap(dsms.dsms_security.decrypt_val(c.cont_last_name, 'EAHMDR')) as cont_last_name
      , dsms.dsms_security.decrypt_val(c.cont_email, 'EAHMDR') as cont_email
      , Email_Rank
from  eahmdr_cim_da.tmp_eloqua_contact_mv c
where  email_rank = 2
  and  cont_valid_email_flag = 'Y';

grant select on tmp_eloqua_contact_dupes_vw to aplafcan, bchiappetta, eahmdr_select_role, eahmdr_dm_user, eahmdr_cim_da;

select count(1), count(distinct cont_id) from tmp_eloqua_contact_dupes_vw;
--1	1373	1373

--select count(1) from tmp_eloqua_contact_dupes_vw where cont_email is null or cont_valid_email_flag = 'N';
--0

select Email_Rank, count(1), count(distinct cont_id) from tmp_eloqua_contact_dupes_vw group by Email_Rank;
--EMAIL_RANK	COUNT(1)	COUNT(DISTINCTCONT_ID)
2	1373	1373



