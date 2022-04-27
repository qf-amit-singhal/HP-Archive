use cim_views_db
go 

if object_id('cim_comm_channel_class_vw') is not null drop view cim_comm_channel_class_vw
go 

create view cim_comm_channel_class_vw as (
select communication_id, cc.name as CM_CHANNEL_CLASS
from   cim_meta_db.dbo.CM_COMM_PACKAGE comm_pkg
join   cim_meta_db.dbo.CM_CHANNEL_CLASS cc on comm_pkg.Channel_Class_Id = cc.Channel_Class_Id
group by communication_id, cc.name 
)
