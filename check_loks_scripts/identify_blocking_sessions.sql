SELECT 
    spid, 
    blocking_session_id, 
    wait_time, 
    last_wait_type, 
    cpu_time, 
    total_elapsed_time,
    login_time,
    host_name,
    program_name,
    login_name,
    status,
    command
FROM 
    sys.dm_exec_requests 
    CROSS APPLY sys.dm_exec_sql_text(sql_handle)
WHERE 
    blocking_session_id <> 0;

