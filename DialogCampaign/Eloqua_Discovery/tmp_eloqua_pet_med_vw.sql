create or replace view tmp_eloqua_pet_med_vw as 
select /*pet medicine info*/
       pm.acct_cont_id
     , pm.pp_id
     , pm.cont_id pet_cont_id
     , pm.acc_name
     , pm.prod_code
     , pm.product as product_name
     , pm.trademark
     , pm.established_name
     , to_char(pm.pp_last_dose,'MM/DD/YYYY') as last_dosage_date
     , pm.pp_doses_remaining as doses_remaining
     , to_char(pm.refill_rem_date, 'MM/DD/YYYY') refill_rem_date
     , to_char(pm.dosage_rem_date, 'MM/DD/YYYY') dosage_rem_date
     , to_char(pm.calc_last_dose_date, 'MM/DD/YYYY') calc_last_dose_date
     , pm.last_dose_administered
       /*pet information*/
     , c.cont_first_name as pet_name
     , c.cont_active_flag as pet_active_flag
     , pet.pet_weight
     , b.breed_name
     , s.species_name
      /*Reminders Opt*/
     , email_opt.capref_flag as Reminders_Opt_Email
     , sms_opt.capref_flag as Reminders_Opt_SMS
     /*owner information*/
     , owner.cont_id 
     , owner.cont_first_name
     , dsms.dsms_security.decrypt_val(owner.cont_last_name,'EAHMDR') cont_last_name
     , case when owner.cont_valid_email_flag = 'Y' then dsms.dsms_security.decrypt_val(owner.cont_email, 'EAHMDR') end cont_email
     , owner.cont_mobile
from   eahmdr_cim_da.tmp_eloqua_pet_med_mv pm
join   eahmdr_cim_da.tmp_eloqua_pet_sample e on pm.cont_id = e.cont_id
join   eahmdr.contact c on pm.cont_id = c.cont_id
join   eahmdr.app_pet pet on c.cont_id = pet.cont_id
join   eahmdr_cim_da.tmp_eloqua_contact_mv owner on c.cont_parent_id = owner.cont_id
left join eahmdr.app_breed b on pet.breed_id = b.breed_id
left join eahmdr.app_species s on b.species_id = s.species_id
left join eahmdr_cim_da.tmp_eloqua_pref_mv email_opt on pm.acct_cont_id = email_opt.acct_cont_id and email_opt.cch_type = 'EMAIL' and email_opt.pt_code like '%REMINDERS%'
left join eahmdr_cim_da.tmp_eloqua_pref_mv sms_opt on pm.acct_cont_id = sms_opt.acct_cont_id and email_opt.cch_type = 'SMS' and sms_opt.pt_code like '%REMINDERS%';

grant select on tmp_eloqua_pet_med_vw to aplafcan, bchiappetta, eahmdr_select_role, eahmdr_dm_user, eahmdr_cim_da;

select count(1), count(distinct acct_cont_id)
     , count(distinct pet_cont_id), count(distinct cont_id)
from tmp_eloqua_pet_med_vw;
--1	78344	78344	78316	60633


