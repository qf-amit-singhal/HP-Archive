SELECT d.name, snapshot_isolation_state, snapshot_isolation_state_desc,  is_read_committed_snapshot_on , 
 CASE 
 WHEN transaction_isolation_level = 1 
 THEN 'READ UNCOMMITTED' 
 WHEN transaction_isolation_level = 2 
 AND is_read_committed_snapshot_on = 1 
 THEN 'READ COMMITTED SNAPSHOT' 
 WHEN transaction_isolation_level = 2 
 AND is_read_committed_snapshot_on = 0 THEN 'READ COMMITTED' 
 WHEN transaction_isolation_level = 3 
 THEN 'REPEATABLE READ' 
 WHEN transaction_isolation_level = 4 
 THEN 'SERIALIZABLE' 
 WHEN transaction_isolation_level = 5 
 THEN 'SNAPSHOT' 
 ELSE NULL
END AS TRANSACTION_ISOLATION_LEVEL, d.*
FROM sys.dm_exec_sessions AS s
CROSS JOIN sys.databases AS d 
where name like 'cim%' 


SELECT d.name, snapshot_isolation_state, snapshot_isolation_state_desc,  is_read_committed_snapshot_on 
FROM sys.dm_exec_sessions AS s
CROSS JOIN sys.databases AS d 
where name like 'cim%' 

