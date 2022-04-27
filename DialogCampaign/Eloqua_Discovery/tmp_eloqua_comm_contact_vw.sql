create or replace view tmp_eloqua_comm_contact_vw as 
select cc.cc_id
     , cc.cont_id
     , cast(null as number) pet_cont_id
     , to_char(cc.cc_date, 'MM/DD/YYYY') cc_date
     , comm.comm_id
     , comm.cmt_id
     , comm.cch_id 
     , comm.acc_id
     , comm.comm_code
     , comm.comm_descr
     , comm.comm_external_id
     , to_char(comm.comm_start_date, 'MM/DD/YYYY') comm_start_date
     , to_char(comm.comm_end_date, 'MM/DD/YYYY') comm_end_date
     , comm.parent_comm_id
     , pcomm.comm_code campaign_code
     , pcomm.comm_descr campaign_descr
     , acc_name
     , cmt.cmt_code
     , cch.cch_type
     , cc.sc_code
     , to_char(cc.cc_create_date, 'MM/DD/YYYY HH:MI:SS') cc_create_date
     , to_char(cc.cc_update_date, 'MM/DD/YYYY HH:MI:SS') cc_update_date
from   eahmdr.communication_contact cc
join   eahmdr_cim_da.tmp_eloqua_contact_sample e on cc.cont_id = e.cont_id
join   eahmdr.contact c on cc.cont_id = c.cont_id
join   eahmdr.communication comm on cc.comm_id = comm.comm_id
join   eahmdr.communication pcomm on comm.parent_comm_id = pcomm.comm_id
join   eahmdr.communication_type cmt on comm.cmt_id = cmt.cmt_id
join   eahmdr.account acc on acc.acc_id = comm.acc_id
left join eahmdr.communication_channel cch on comm.cch_id = cch.cch_id
where  cmt.cmt_code <> 'REBATE'
union all
select cc.cc_id
     , c.cont_parent_id cont_id
     , cc.cont_id pet_cont_id
     , to_char(cc.cc_date, 'MM/DD/YYYY') cc_date
     , comm.comm_id
     , comm.cmt_id
     , comm.cch_id 
     , comm.acc_id
     , comm.comm_code
     , comm.comm_descr
     , comm.comm_external_id
     , to_char(comm.comm_start_date, 'MM/DD/YYYY') comm_start_date
     , to_char(comm.comm_end_date, 'MM/DD/YYYY') comm_end_date
     , comm.parent_comm_id
     , pcomm.comm_code campaign_code
     , pcomm.comm_descr campaign_descr
     , acc_name
     , cmt.cmt_code
     , cch.cch_type
     , cc.sc_code
     , to_char(cc.cc_create_date, 'MM/DD/YYYY HH:MI:SS') cc_create_date
     , to_char(cc.cc_update_date, 'MM/DD/YYYY HH:MI:SS') cc_update_date
from   eahmdr.communication_contact cc
join   eahmdr_cim_da.tmp_eloqua_pet_sample e on cc.cont_id = e.cont_id
join   eahmdr.contact c on cc.cont_id = c.cont_id
join   eahmdr.communication comm on cc.comm_id = comm.comm_id
join   eahmdr.communication pcomm on comm.parent_comm_id = pcomm.comm_id
join   eahmdr.communication_type cmt on comm.cmt_id = cmt.cmt_id
join   eahmdr.account acc on acc.acc_id = comm.acc_id
left join eahmdr.communication_channel cch on comm.cch_id = cch.cch_id
where  cmt.cmt_code <> 'REBATE';

grant select on tmp_eloqua_comm_contact_vw to aplafcan, bchiappetta, eahmdr_select_role, eahmdr_dm_user, eahmdr_cim_da;

select count(1), count(distinct cc_id)
from tmp_eloqua_comm_contact_vw;
--1	240654	240654


