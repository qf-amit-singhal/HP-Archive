begin
  execute immediate 'drop materialized view tmp_eloqua_pref_mv';
exception
 when others then
  null;
end;
/


create materialized view tmp_eloqua_pref_mv
 refresh complete
 as
 
select ac.acct_cont_id, cap.cont_id, pt.acc_id, acc_name, pt.pt_code, cch.cch_id, cch_type, cap.capref_flag
from   eahmdr.contact_acct_preference cap
join   eahmdr.communication_channel cch on cap.cch_id = cch.cch_id
join   eahmdr.preference_type pt on pt.pt_id = cap.pt_id
join   eahmdr.account acc on pt.acc_id = acc.acc_id
left join eahmdr.account_contact ac on cap.cont_id = ac.cont_id and acc.acc_id = ac.acc_id
where  cap.cont_id in (select cont_id from eahmdr_cim_da.tmp_eloqua_contact_sample)
   or  cap.cont_id in (select cont_id from eahmdr_cim_da.tmp_eloqua_pet_sample);
   
create index TMP_EPREF_ACCTCONT_IDX on tmp_eloqua_pref_mv(acct_cont_id);
create index TMP_EPREF_CONT_IDX on tmp_eloqua_pref_mv(cont_id);
create index TMP_EPREF_PT_IDX on tmp_eloqua_pref_mv(pt_code);
create index TMP_EPREF_CCH_IDX on tmp_eloqua_pref_mv(cch_type);

grant select on tmp_eloqua_pref_mv to aplafcan, bchiappetta, eahmdr_select_role, eahmdr_cim_role, eahmdr_dm_user;
grant select on tmp_eloqua_pref_mv to eahmdr_cim_views with grant option;


