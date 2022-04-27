/*GLOBALLY REPLACE appcode with appcode*/


/*File Export Records*/
select * from appcode.file_export;

/*Destination Log Records*/
select dj_code, dl.* 
from appcode.destination_log dl
join appcode.destination_job dj on dj.dj_id = dl.dj_id
order by dl_id desc;


/*Quick Count for Pending records by OUT Table*/
select 'EMAIL', count(1) from appcode.email_out where sc_code like '%PENDING' union all
select 'DM', count(1) from appcode.dm_out where sc_code like '%PENDING' union all
select 'CALL', count(1) from appcode.call_out where sc_code like '%PENDING' union all
select 'SOCIAL', count(1) from appcode.social_out where sc_code like '%PENDING';


/*Counts by OUT table*/
select * from (
select 'EMAIL_OUT' out_table, dj_code, dl.dl_id, trunc(eo_create_date) out_create_date, eo.sc_code out_sc_code, eo.comm_code out_comm_code, count(distinct eo_id) out_count
from appcode.email_out eo
left join appcode.destination_log dl on eo.dl_id = dl.dl_id
left join appcode.destination_job dj on dl.dj_id = dj.dj_id
group by dj_code, dl.dl_id, trunc(eo_create_date) , eo.sc_code, eo.comm_code
union all  
select 'DM_OUT' out_table, dj_code, dl.dl_id, trunc(dmo_create_date) out_create_date, dmo.sc_code out_sc_code, dmo.comm_code out_comm_code, count(distinct dmo_id) out_count
from appcode.dm_out dmo
left join appcode.destination_log dl on dmo.dl_id = dl.dl_id
left join appcode.destination_job dj on dl.dj_id = dj.dj_id
group by dj_code, dl.dl_id, trunc(dmo_create_date) , dmo.sc_code, dmo.comm_code
union all
select 'CALL_OUT' out_table, dj_code, dl.dl_id, trunc(co_create_date) out_create_date, co.sc_code out_sc_code, co.comm_code out_comm_code, count(distinct co_id) out_count 
from appcode.call_out co
left join appcode.destination_log dl on co.dl_id = dl.dl_id
left join appcode.destination_job dj on dl.dj_id = dj.dj_id
group by dj_code, dl.dl_id, trunc(co_create_date) , co.sc_code, co.comm_code
union all
select 'SOCIAL_OUT' out_table, dj_code, dl.dl_id, trunc(soco_create_date) out_create_date, soco.sc_code out_sc_code, soco.comm_code out_comm_code, count(distinct soco_id) out_count
from appcode.social_out soco
left join appcode.destination_log dl on soco.dl_id = dl.dl_id
left join appcode.destination_job dj on dl.dj_id = dj.dj_id
group by dj_code, dl.dl_id, trunc(soco_create_date) , soco.sc_code, soco.comm_code
) x
--where trunc(out_create_date) >= trunc(sysdate)
--where out_sc_code like '%PENDING'
order by out_table, out_create_date desc, dj_code, out_comm_code, dl_id desc nulls first;



/*Counts by OUT table with communication contact info*/
select * from (
select 'EMAIL_OUT' out_table, dj_code, dl.dl_id, trunc(eo_create_date) out_create_date, eo.sc_code out_sc_code, eo.comm_code out_comm_code, 
        count(distinct eo_id) out_count, count(distinct cc.cc_id) cc_count,
        comm.comm_code cc_comm_code, trunc(cc.cc_date) cc_date, trunc(cc.cc_create_date) cc_create_date, trunc(cc.cc_update_date) cc_update_date, cc.sc_code cc_sc_code, max(cc.cc_id)     
from appcode.email_out eo
left join appcode.destination_log dl on eo.dl_id = dl.dl_id
left join appcode.destination_job dj on dl.dj_id = dj.dj_id
left join appcode.communication_contact cc on eo.cc_id = cc.cc_id 
left join appcode.communication comm on cc.comm_id = comm.comm_id
group by dj_code, dl.dl_id, trunc(eo_create_date) , eo.sc_code, eo.comm_code, comm.comm_code, trunc(cc.cc_date), trunc(cc.cc_update_date) , trunc(cc.cc_update_date), trunc(cc.cc_create_date), cc.sc_code
union all  
select 'DM_OUT' out_table, dj_code, dl.dl_id, trunc(dmo_create_date) out_create_date, dmo.sc_code out_sc_code, dmo.comm_code out_comm_code, 
        count(distinct dmo_id) out_count, count(distinct cc.cc_id) cc_count,
        comm.comm_code cc_comm_code, trunc(cc.cc_date) cc_date, trunc(cc.cc_create_date) cc_create_date, trunc(cc.cc_update_date) cc_update_date, cc.sc_code cc_sc_code, max(cc.cc_id)   
from appcode.dm_out dmo
left join appcode.destination_log dl on dmo.dl_id = dl.dl_id
left join appcode.destination_job dj on dl.dj_id = dj.dj_id
left join appcode.communication_contact cc on dmo.cc_id = cc.cc_id 
left join appcode.communication comm on cc.comm_id = comm.comm_id
group by dj_code, dl.dl_id, trunc(dmo_create_date) , dmo.sc_code, dmo.comm_code, comm.comm_code, trunc(cc.cc_date), trunc(cc.cc_update_date) , trunc(cc.cc_create_date), cc.sc_code
union all
select 'CALL_OUT' out_table, dj_code, dl.dl_id, trunc(co_create_date) out_create_date, co.sc_code out_sc_code, co.comm_code out_comm_code, 
        count(distinct co_id) out_count, count(distinct cc.cc_id) cc_count,
        comm.comm_code cc_comm_code, trunc(cc.cc_date) cc_date, trunc(cc.cc_create_date) cc_create_date, trunc(cc.cc_update_date) cc_update_date, cc.sc_code cc_sc_code, max(cc.cc_id)    
from appcode.call_out co
left join appcode.destination_log dl on co.dl_id = dl.dl_id
left join appcode.destination_job dj on dl.dj_id = dj.dj_id
left join appcode.communication_contact cc on co.cc_id = cc.cc_id 
left join appcode.communication comm on cc.comm_id = comm.comm_id
group by dj_code, dl.dl_id, trunc(co_create_date) , co.sc_code, co.comm_code, comm.comm_code, trunc(cc.cc_date), trunc(cc.cc_create_date), trunc(cc.cc_update_date), cc.sc_code
union all
select 'SOCIAL_OUT' out_table, dj_code, dl.dl_id, trunc(soco_create_date) out_create_date, soco.sc_code out_sc_code, soco.comm_code out_comm_code, 
        count(distinct soco_id) out_count, count(distinct cc.cc_id) cc_count,
        comm.comm_code cc_comm_code, trunc(cc.cc_date) cc_date, trunc(cc.cc_create_date) cc_create_date, trunc(cc.cc_update_date) cc_update_date, cc.sc_code cc_sc_code, max(cc.cc_id)    
from appcode.social_out soco
left join appcode.destination_log dl on soco.dl_id = dl.dl_id
left join appcode.destination_job dj on dl.dj_id = dj.dj_id
left join appcode.communication_contact cc on soco.cc_id = cc.cc_id 
left join appcode.communication comm on cc.comm_id = comm.comm_id
group by dj_code, dl.dl_id, trunc(soco_create_date) , soco.sc_code, soco.comm_code, comm.comm_code, trunc(cc.cc_date), trunc(cc.cc_create_date), trunc(cc.cc_update_date), cc.sc_code
) x
--where trunc(out_create_date) >= trunc(sysdate)
--where out_sc_code like '%PENDING'
order by out_table, out_create_date desc, dj_code, out_comm_code, dl_id desc nulls first;

/*Communication Contact Counts*/
select pcomm.comm_code parent_comm, pcomm.comm_descr parent_comm_descr, pcmt.cmt_code parent_comm_type, pcch.cch_type parent_comm_channel,
       comm.comm_code, comm.comm_descr, cmt.cmt_code, cch.cch_type, comm.comm_external_id, comm.comm_start_date, comm.comm_end_date, trunc(cc.cc_date) cc_date, count(1) 
from   appcode.communication_contact cc
join   appcode.communication comm on cc.comm_id = comm.comm_id
join   appcode.communication_type cmt on comm.cmt_id = cmt.cmt_id
left join appcode.communication_channel cch on comm.cch_id = cch.cch_id
left join appcode.communication pcomm on comm.parent_comm_id = pcomm.comm_id
left join appcode.communication_type pcmt on pcomm.cmt_id = pcmt.cmt_id
left join appcode.communication_channel pcch on pcomm.cch_id = pcch.cch_id
where cmt.cmt_code = 'TOUCH'
--  and pcomm.comm_code in ()
--  and comm.comm_code in ()
--  and cc.cc_date >= trunc(sysdate) - 7
group by pcomm.comm_code, pcomm.comm_descr, pcmt.cmt_code, pcch.cch_type,
       comm.comm_code, comm.comm_descr, cmt.cmt_code, cch.cch_type, comm.comm_external_id, comm.comm_start_date, comm.comm_end_date, trunc(cc.cc_date)
order by pcomm.comm_code, comm.comm_code, trunc(cc.cc_date) desc;
