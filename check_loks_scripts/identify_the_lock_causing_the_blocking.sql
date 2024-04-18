SELECT 
    t.resource_type,
    t.request_mode,
    t.request_status,
    t.request_owner_type,
    t.request_owner_id,
    t.resource_associated_entity_id,
    t.request_session_id,
    r.blocking_session_id,
    t.resource_description,
    p.[text] AS BlockedQuery,
    r.[text] AS BlockingQuery
FROM 
    sys.dm_tran_locks AS t
INNER JOIN 
    sys.dm_exec_requests AS r ON t.request_session_id = r.session_id
CROSS APPLY 
    sys.dm_exec_sql_text(r.[sql_handle]) AS p
CROSS APPLY 
    sys.dm_exec_sql_text(t.[resource_associated_entity_id]) AS q
WHERE 
    r.blocking_session_id <> 0;

