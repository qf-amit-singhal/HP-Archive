select table_name
     , 'drop table ' || table_name || ';'
     , 'select count(1) from ' || table_name || ';--'
from all_tables where OWNER = 'EAHMDR_CIM_DA' and table_name like 'TMP%';

/*
drop table TMP_BLACKHAWK_REBATE;
drop table TMP_CONT_NO_EMAIL;
drop table TMP_CONT_SHARED_EMAIL;
drop table TMP_OWNERS_DD_COMMS;
drop table TMP_OWNER_MULTIPLE_PETS;
drop table TMP_OWNER_NO_OPT;
drop table TMP_OWNER_OPT;
drop table TMP_OWNER_SINGLE_PETS;
drop table TMP_PETS_DD_COMMS;
drop table TMP_PET_ACTIVE_DOSAGE;
drop table TMP_PET_NO_OPT;
drop table TMP_PREF_CENTER;
drop table tmp_emails_3plus_cont;
*/


create table tmp_owner_multiple_pets as
select cont_parent_id cont_id
from   eahmdr.contact c
join   eahmdr.contact_type ct on c.ct_id = ct.ct_id
where  ct.ct_code = 'PET'
group  by cont_parent_id
having count(cont_id) > 1;

create index ix_tmp_omp_cont_id on tmp_owner_multiple_pets(cont_id);

create table tmp_owner_single_pets as
select cont_parent_id cont_id
from   eahmdr.contact c
join   eahmdr.contact_type ct on c.ct_id = ct.ct_id
where  ct.ct_code = 'PET'
group  by cont_parent_id
having count(cont_id) = 1;

create index ix_tmp_osp_cont_id on tmp_owner_single_pets(cont_id);

create table tmp_owners_dd_comms as 
select cont_id, count(cc_id) total_comms
from   eahmdr.communication_contact cc
join   eahmdr.communication comm on cc.comm_id = comm.comm_id
join   eahmdr.communication pcomm on pcomm.comm_id = comm.parent_comm_id
where  pcomm.comm_code in ('TRIFEXIS_QUARTERLY_NEWSLETTER'
                          ,'TRIFEXIS_WEB_LAUNCH'
                          ,'QUARTERLY_FACEBOOK_RETARGETING'
                          ,'PREFLAUNCH')
group by cont_id;

create index ix_tmp_oddcomm_cont_id on tmp_owners_dd_comms(cont_id);

create table tmp_pets_dd_comms as 
select cc.cont_id pet_cont_id, c.cont_parent_id owner_cont_id, count(cc_id) total_comms, count(distinct comm.cch_id) total_channels
from   eahmdr.communication_contact cc
join   eahmdr.contact c on cc.cont_id = c.cont_id
join   eahmdr.communication comm on cc.comm_id = comm.comm_id
join   eahmdr.communication pcomm on pcomm.comm_id = comm.parent_comm_id
where  pcomm.comm_code in ('DOSAGE_REMINDERS'
                          ,'REFILL_REMINDERS')
group by cc.cont_id, c.cont_parent_id;

create index ix_tmp_pet_dd_pet on tmp_pets_dd_comms(pet_cont_id);
create index ix_tmp_pet_dd_owner on tmp_pets_dd_comms(owner_cont_id);


create table tmp_pref_center as 
select  distinct wa.cont_id
from    eahmdr.web_account wa
join    eahmdr.web_access_log wal on wa.wa_id = wal.wa_id
where   wal.wal_logon_success_flag = 'Y';
create table tmp_blackhawk_rebate as 
select c.cont_parent_id cont_id, count(cc_id) total_comms
from   eahmdr.communication_contact cc
join   eahmdr.communication comm on cc.comm_id = comm.comm_id
join   eahmdr.communication pcomm on pcomm.comm_id = comm.parent_comm_id
join   eahmdr.contact c on cc.cont_id = c.cont_id
where  pcomm.comm_code in ('BLACKHAWKREBATE')
group by cont_parent_id;

create index ix_tmp_pref on tmp_pref_center(cont_id);


create table tmp_owner_opt as 
select cont_id
from   eahmdr.contact c
join   eahmdr.contact_type ct on c.ct_id = ct.ct_id
where  ct_code = 'CONSUMER'
  and  exists (select 1
               from   eahmdr.contact_acct_preference cap
               where  cap.capref_flag = 'Y'
                 and  cap.cont_id = c.cont_id
               )
;

create index ix_tmp_o_opt on tmp_owner_opt(cont_id);

create table tmp_owner_no_opt as 
select cont_id
from   eahmdr.contact c
join   eahmdr.contact_type ct on c.ct_id = ct.ct_id
where  ct_code = 'CONSUMER'
  and  not exists (select 1
                   from   eahmdr.contact_acct_preference cap
                   where  cap.capref_flag = 'Y'
                     and  cap.cont_id = c.cont_id
                   )
;

create index ix_tmp_o_noopt on tmp_owner_no_opt(cont_id);

create table tmp_pet_no_opt as 
select cont_id pet_cont_id, c.cont_parent_id owner_cont_id
from   eahmdr.contact c
join   eahmdr.contact_type ct on c.ct_id = ct.ct_id
where  ct_code = 'PET'
  and  not exists (select 1
                   from   eahmdr.contact_acct_preference cap
                   where  cap.capref_flag = 'Y'
                     and  cap.cont_id = c.cont_id
                   )
;

create index ix_tmp_p_pnoopt on tmp_pet_no_opt(pet_cont_id);
create index ix_tmp_o_pnoopt on tmp_pet_no_opt(owner_cont_id);

               
create table tmp_pet_active_dosage as
select cont_id pet_cont_id, c.cont_parent_id owner_cont_id
from   eahmdr.contact c
join   eahmdr.contact_type ct on c.ct_id = ct.ct_id
where  ct_code = 'PET'
  and  exists (select 1
               from   eahmdr.app_cim_dosage_reminder_mv d
               where  d.cont_id = c.cont_id
               and  calc_last_dose_date >= '16-MAY-2017'
               )
;

create index ix_tmp_p_active_dosage on tmp_pet_active_dosage(pet_cont_id);
create index ix_tmp_o_active_dosage on tmp_pet_active_dosage(owner_cont_id);

create table tmp_cont_no_email as
select cont_id
from   eahmdr.contact c
join   eahmdr.contact_type ct on c.ct_id = ct.ct_id
where  ct_code = 'CONSUMER'
  and  c.cont_email is null
  and  c.cont_create_date >= '01-JUL-2017';

insert into tmp_cont_no_email
select cont_id
from   eahmdr.contact c
join   eahmdr.contact_type ct on c.ct_id = ct.ct_id
where  ct_code = 'CONSUMER'
  and  c.cont_email is null
  and  c.cont_id in (select cont_id 
                     from eahmdr.account_contact ac 
                     join eahmdr.account acc on ac.acc_id = acc.acc_id
                     where acc_name = 'TRIFEXIS'
                     )
  and cont_id not in (select cont_id from tmp_cont_no_email);
commit;

create index ix_tmp_cont_no_email on tmp_cont_no_email(cont_id);

create table tmp_cont_shared_email as
select cont_id, cont_email
from   eahmdr.contact
where  cont_email in (select cont_email
                      from   eahmdr.contact c
                      join   eahmdr.contact_type ct on c.ct_id = ct.ct_id
                      where  ct_code = 'CONSUMER'
                        and  cont_id in (select cont_id from tmp_owners_dd_comms)
                      group by cont_email 
                      having count(1) = 2
                     );

create index ix_tmp_cont_shared_email on tmp_cont_shared_email(cont_id);
create index ix2_tmp_cont_shared_email on tmp_cont_shared_email(cont_email);

create table tmp_emails_3plus_cont as
select cont_id, cont_email
from   eahmdr.contact
where  cont_email in (select cont_email
                      from   eahmdr.contact c
                      join   eahmdr.contact_type ct on c.ct_id = ct.ct_id
                      where  ct_code = 'CONSUMER'
                        and  cont_email is not null
                      group by cont_email 
                      having count(1) > 2
                     );
                     
create index ix_tmp_emails_3plus_cont on tmp_emails_3plus_cont(cont_id);
create index ix3_tmp_emails_3plus_cont on tmp_emails_3plus_cont(cont_email);
      
select count(1) from tmp_blackhawk_rebate;--312574
select count(1) from tmp_cont_no_email;--53454
select count(1) from tmp_cont_shared_email;--18805
select count(1) from tmp_owners_dd_comms;--412689
select count(1) from tmp_owner_multiple_pets;--560749
select count(1) from tmp_owner_no_opt;--907994
select count(1) from tmp_owner_opt;--1650776
select count(1) from tmp_owner_single_pets;--1998052
select count(1) from tmp_pets_dd_comms;--27155
select count(1) from tmp_pet_active_dosage;--1804
select count(1) from tmp_pet_no_opt;--3022675
select count(1) from tmp_pref_center;--8529
select count(1) from tmp_emails_3plus_cont;--93598

--drop table tmp_eloqua_contact_sample;
create table tmp_eloqua_contact_sample as 
select a.cont_id, cast('SINGLE_PET' as varchar(100)) Selection_Criteria
from   tmp_owner_single_pets  a
join   tmp_owners_dd_comms b on a.cont_id = b.cont_id
join   tmp_owner_opt c on a.cont_id = c.cont_id
--259658
where  rownum <= 20000;

insert into tmp_eloqua_contact_sample
select a.cont_id, 'MULITPLE_PET'
from   tmp_owner_multiple_pets a
join   tmp_owners_dd_comms b on a.cont_id = b.cont_id
join   tmp_owner_opt c on a.cont_id = c.cont_id
left join tmp_eloqua_contact_sample e on a.cont_id = e.cont_id
left join tmp_emails_3plus_cont e3 on a.cont_id = e3.cont_id
where e.cont_id is null
  and e3.cont_id is null
  and rownum <= 50000;

insert into tmp_eloqua_contact_sample
select a.cont_id, 'PREF_CENTER'
from   eahmdr.contact a
join   tmp_pref_center b on a.cont_id = b.cont_id
left join tmp_eloqua_contact_sample e on a.cont_id = e.cont_id
left join tmp_emails_3plus_cont e3 on a.cont_id = e3.cont_id
where e.cont_id is null
  and e3.cont_id is null
  and rownum <= 5000;

insert into tmp_eloqua_contact_sample
select a.cont_id, 'REBATE'
from   eahmdr.contact a
join   tmp_blackhawk_rebate b on a.cont_id = b.cont_id
left join tmp_eloqua_contact_sample e on a.cont_id = e.cont_id
left join tmp_emails_3plus_cont e3 on a.cont_id = e3.cont_id
where e.cont_id is null
  and e3.cont_id is null
  and rownum <= 5000;
  
insert into tmp_eloqua_contact_sample
select a.cont_id, 'OWNER_NO_OPT'
from   eahmdr.contact a
join   tmp_owner_no_opt b on a.cont_id = b.cont_id
left join tmp_eloqua_contact_sample e on a.cont_id = e.cont_id
left join tmp_emails_3plus_cont e3 on a.cont_id = e3.cont_id
where e.cont_id is null
  and e3.cont_id is null
  and rownum <= 5000;

insert into tmp_eloqua_contact_sample
select distinct a.cont_id, 'PET_NO_OPT'
from   eahmdr.contact a
join   tmp_pet_no_opt b on a.cont_id = b.owner_cont_id
left join tmp_eloqua_contact_sample e on a.cont_id = e.cont_id
left join tmp_emails_3plus_cont e3 on a.cont_id = e3.cont_id
where e.cont_id is null
  and e3.cont_id is null
  and rownum <= 5000;

insert into tmp_eloqua_contact_sample
select distinct a.cont_id, 'PET_DD_COMMS_SINGLE_CHANNEL'
from   eahmdr.contact a
join   tmp_pets_dd_comms b on a.cont_id = b.owner_cont_id
left join tmp_eloqua_contact_sample e on a.cont_id = e.cont_id
left join tmp_emails_3plus_cont e3 on a.cont_id = e3.cont_id
where e.cont_id is null
  and e3.cont_id is null
  and total_channels = 1
  and total_comms > 1
  and rownum <= 5000;

insert into tmp_eloqua_contact_sample
select distinct a.cont_id, 'PET_DD_COMMS_MULTI_CHANNEL'
from   eahmdr.contact a
join   tmp_pets_dd_comms b on a.cont_id = b.owner_cont_id
left join tmp_eloqua_contact_sample e on a.cont_id = e.cont_id
left join tmp_emails_3plus_cont e3 on a.cont_id = e3.cont_id
where e.cont_id is null
  and e3.cont_id is null
  and total_channels > 1
  and total_comms > 1
  and rownum <= 5000;

insert into tmp_eloqua_contact_sample
select distinct a.cont_id, 'ACTIVE_DOSAGE'
from   eahmdr.contact a
join   tmp_pet_active_dosage b on a.cont_id = b.owner_cont_id
left join tmp_eloqua_contact_sample e on a.cont_id = e.cont_id
left join tmp_emails_3plus_cont e3 on a.cont_id = e3.cont_id
where e.cont_id is null
  and e3.cont_id is null;

insert into tmp_eloqua_contact_sample
select a.cont_id, 'CONT_NO_EMAIL'
from   eahmdr.contact a
join   tmp_cont_no_email b on a.cont_id = b.cont_id
left join tmp_eloqua_contact_sample e on a.cont_id = e.cont_id
where e.cont_id is null
  and rownum <= 5000;

insert into tmp_eloqua_contact_sample
select a.cont_id, 'CONT_SHARED_EMAIL'
from   eahmdr.contact a
left join tmp_eloqua_contact_sample e on a.cont_id = e.cont_id
where e.cont_id is null
  and a.cont_email in (select distinct cont_email
                       from   tmp_cont_shared_email 
                       where  rownum <= 5000
                       );
  
commit;

delete from tmp_eloqua_contact_sample
where cont_id in (select cont_id
                  from   eahmdr.contact
                  where  cont_email in (select c.cont_email
                                        from eahmdr.contact c
                                        join tmp_eloqua_contact_sample e on c.cont_id = e.cont_id
                                        where c.cont_email is not null
                                        group by c.cont_email
                                        having count(1) > 2
                                        )
                  );
--2896

commit;
select count(1)
from eahmdr.contact c
join tmp_eloqua_contact_sample e on c.cont_id = e.cont_id
where c.cont_email is null;
--6607

select Total, count(1)
from (select c.cont_email, count(1) Total
      from eahmdr.contact c
      join tmp_eloqua_contact_sample e on c.cont_id = e.cont_id
      where c.cont_email is not null
      group by c.cont_email
      ) x
group by Total
order by 1;
/*TOTAL	COUNT(1)
1	91900
2	1377*/

--drop table tmp_eloqua_pet_sample;
create table tmp_eloqua_pet_sample as
select cp.cont_id
from   tmp_eloqua_contact_sample e
join   eahmdr.contact c on e.cont_id = c.cont_id
join   eahmdr.contact cp on c.cont_id = cp.cont_parent_id;

select count(1) from tmp_eloqua_contact_sample;--101261
select count(1) from tmp_eloqua_pet_sample;--209706

create index ix_tmp_eloqua_cont_id on tmp_eloqua_contact_sample(cont_id);
grant select on tmp_eloqua_contact_sample to aplafcan, bchiappetta, eahmdr_select_role, eahmdr_cim_role, eahmdr_dm_user;

create index ix_tmp_eloqua_pet_cont_id on tmp_eloqua_pet_sample(cont_id);
grant select on tmp_eloqua_pet_sample to aplafcan, bchiappetta, eahmdr_select_role, eahmdr_cim_role, eahmdr_dm_user;

grant select on tmp_eloqua_contact_sample to eahmdr_cim_views with grant option;
grant select on tmp_eloqua_pet_sample to eahmdr_cim_views with grant option;
