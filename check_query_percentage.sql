SELECT 
    r.session_id,
    r.percent_complete,
    r.status,
    r.command,
    t.text AS [SQL Text]
FROM 
    sys.dm_exec_requests r
    CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE 
    r.session_id > 52 -- Filtre a solicitação específica se necessário
    AND r.command IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE') -- Filtre comandos relevantes
ORDER BY 
    r.session_id;
