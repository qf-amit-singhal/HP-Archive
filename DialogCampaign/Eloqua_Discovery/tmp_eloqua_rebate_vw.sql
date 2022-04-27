create or replace view tmp_eloqua_rebate_vw as 
 select  cc.cc_id
       , c.cont_parent_id cont_id
       , cc.cont_id pet_cont_id
       , comm.comm_id
       , comm.comm_code
       , comm.comm_descr
       , comm.comm_external_id
       , comm.comm_start_date
       , comm.comm_end_date
       , pcomm.comm_code campaign_code
       , pcomm.comm_descr campaign_descr
       , acc_name
       , to_char(cc.cc_date,'MM/DD/YYYY') Rebate_Submission_Date
       , (select ccat.ccat_attr_value
          from   eahmdr.comm_contact_attribute ccat
          join   eahmdr.attribute a on ccat.attr_id = a.attr_id
          where  ccat.cc_id = cc.cc_id
            and  attr_name = 'CCAT_POSTMARK_DATE'
          ) as Rebate_Postmark_Date     
       , (select ccat.ccat_attr_value
          from   eahmdr.comm_contact_attribute ccat
          join   eahmdr.attribute a on ccat.attr_id = a.attr_id
          where  attr_name = 'CCAT_PURCHASE_DATE'
            and  ccat.cc_id = cc.cc_id
          ) as Rebate_Purchase_Date     
       , (select ccat.ccat_attr_value
          from   eahmdr.comm_contact_attribute ccat
          join   eahmdr.attribute a on ccat.attr_id = a.attr_id
          where  ccat.cc_id = cc.cc_id
            and  attr_name = 'CCAT_OFFER_NAME'
          ) as Rebate_Offer_Name   
       , (select ccat.ccat_attr_value
          from   eahmdr.comm_contact_attribute ccat
          join   eahmdr.attribute a on ccat.attr_id = a.attr_id
          where  ccat.cc_id = cc.cc_id
            and  attr_name = 'CCAT_OFFER_CODE'
          ) as Rebate_Offer_Code
     /*Product Fields not yet available*/
     /*, null as Product_Code
     , null as Product_Name
     , null as Product_Dose*/
from   eahmdr.communication_contact cc
join   eahmdr_cim_da.tmp_eloqua_pet_sample e on cc.cont_id = e.cont_id
join   eahmdr.contact c on cc.cont_id = c.cont_id
join   eahmdr.communication comm on cc.comm_id = comm.comm_id
join   eahmdr.communication pcomm on comm.parent_comm_id = pcomm.comm_id
join   eahmdr.communication_type cmt on comm.cmt_id = cmt.cmt_id
join   eahmdr.account acc on acc.acc_id = comm.acc_id
where  cmt.cmt_code = 'REBATE';

grant select on tmp_eloqua_rebate_vw to aplafcan, bchiappetta, eahmdr_select_role, eahmdr_dm_user, eahmdr_cim_da;

select count(1), count(distinct cc_id)
from tmp_eloqua_rebate_vw;
--1	952866	952866


