SELECT TOP 1
    blocking_session_id AS SPID_bloqueador,
    COUNT(*) AS total_blocos
FROM
    sys.dm_tran_locks
WHERE
    request_session_id IN (SELECT session_id FROM sys.dm_exec_requests WHERE blocking_session_id != 0)
GROUP BY
    blocking_session_id
ORDER BY
    total_blocos DESC;
