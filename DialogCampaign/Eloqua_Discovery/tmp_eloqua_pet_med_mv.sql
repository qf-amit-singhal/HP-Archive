begin
  execute immediate 'drop materialized view tmp_eloqua_pet_med_mv';
exception
 when others then
  null;
end;
/


create materialized view tmp_eloqua_pet_med_mv
 refresh complete
 as
 
select  ac.acct_cont_id
      , pp.pp_id
      , pet.cont_id 
      , pp.proda_id
      , pp.pp_last_dose
      , pp.pp_doses_remaining
      , prod.prod_code
      , acc.acc_id
      , acc.acc_name
      , trunc(add_months(pp.pp_last_dose, case when (pp_doses_remaining - 1) <=0 then 0 else (pp_doses_remaining - 1)end )) refill_rem_date
      /*New Dosage Reminder Date Calculation*/
      , to_date(to_char(sysdate,'mm/') || case when cast(to_char(pp_last_dose, 'dd') as number) > cast(to_char(last_day(sysdate),'dd') as number) then to_char(last_day(sysdate),'dd') else to_char(pp_last_dose, 'dd') end || to_char(sysdate, '/yyyy'), 'mm/dd/yyyy') dosage_rem_date
      /*Calculated Last Dosage Date*/
      , trunc(add_months(pp.pp_last_dose, case when (pp_doses_remaining - 1) <=0 then 0 else pp_doses_remaining end)) calc_last_dose_date
      /*Indicator as to whether the last dose has been administered*/
      , case when months_between(sysdate, pp_last_dose) > pp_doses_remaining then 'Y' else 'N' end as Last_Dose_Administered
      /*Product Information for Personalization/Output*/
      , product.aa_attr_value as product
      , trademark.aa_attr_value as trademark
      , established_name.aa_attr_value as established_name
from   eahmdr.app_pet_product pp
join   eahmdr.app_pet pet on pp.pet_id = pet.pet_id
join   eahmdr.product_account proda on pp.proda_id = proda.proda_id
join   eahmdr.account acc on proda.acc_id = acc.acc_id
join   eahmdr.product prod on proda.prod_id = prod.prod_id
join   eahmdr.account_contact ac on pet.cont_id = ac.cont_id and acc.acc_id = ac.acc_id
join   eahmdr_cim_da.tmp_eloqua_pet_sample e on pet.cont_id = e.cont_id
left join ( select aa.acc_id, aa.aa_attr_value
            from   eahmdr.account_attribute aa
            join   eahmdr.attribute a on aa.attr_id = a.attr_id
            where  a.attr_name = 'PRODUCT'
           ) product on product.acc_id = acc.acc_id
left join ( select aa.acc_id, aa.aa_attr_value
            from   eahmdr.account_attribute aa
            join   eahmdr.attribute a on aa.attr_id = a.attr_id
            where  a.attr_name = 'TRADEMARK'
           ) trademark on trademark.acc_id = acc.acc_id
left join ( select aa.acc_id, aa.aa_attr_value
            from   eahmdr.account_attribute aa
            join   eahmdr.attribute a on aa.attr_id = a.attr_id
            where  a.attr_name = 'ESTABLISHED_NAME'
           ) established_name on established_name.acc_id = acc.acc_id
--Dedupe to one Pet Product Record for the Pet & Account with the highest last dosage date
join (select  max(pp.pp_id) as pp_id
      from    eahmdr.app_pet_product pp
      join    eahmdr.app_pet pet on pp.pet_id = pet.pet_id
      join    eahmdr.product_account proda on pp.proda_id = proda.proda_id
      join    eahmdr.product prod on proda.prod_id = prod.prod_id
      --Most Recent Last Dosage Date per pet & account(brand)
      --For Only active app_pet_product records for active products, with a last dosage date
      join   (select  pet.cont_id,
                      proda.acc_id,
                      max(pp.pp_last_dose)  as pp_last_dose
              from    eahmdr.app_pet_product pp
              join    eahmdr.app_pet pet on pp.pet_id = pet.pet_id
              join    eahmdr.product_account proda on pp.proda_id = proda.proda_id
              join    eahmdr.product prod on proda.prod_id = prod.prod_id
              join   eahmdr_cim_da.tmp_eloqua_pet_sample e on pet.cont_id = e.cont_id
              where   pp.pp_active_flag = 'Y'
                and   prod.prod_active_flag = 'Y'
                and   to_char(pp.pp_last_dose, 'yyyy') > '2000'
                and   pp.pp_doses_remaining <= 100
              group by pet.cont_id, proda.acc_id
             ) max_dt on pet.cont_id = max_dt.cont_id
                     and proda.acc_id = max_dt.acc_id
                     and pp.pp_last_dose = max_dt.pp_last_dose
      where  pp.pp_active_flag = 'Y'
        and  prod.prod_active_flag = 'Y'
      group by pet.cont_id, proda.acc_id
      ) maxpp on maxpp.pp_id = pp.pp_id;
           

create index TMP_PETMED_ACCTCONT_IDX on tmp_eloqua_pet_med_mv(acct_cont_id);
create index TMP_PETMED_CONT_IDX on tmp_eloqua_pet_med_mv(cont_id);
create index TMP_PETMED_ACC_IDX on tmp_eloqua_pet_med_mv(acc_id);
create index TMP_PETMED_REMDT_IDX on tmp_eloqua_pet_med_mv(refill_rem_date);
create index TMP_PETMED_DOSDT_IDX on tmp_eloqua_pet_med_mv(dosage_rem_date);

grant select on tmp_eloqua_pet_med_mv to aplafcan, bchiappetta, eahmdr_select_role, eahmdr_cim_role, eahmdr_dm_user;
grant select on tmp_eloqua_pet_med_mv to eahmdr_cim_views with grant option;
