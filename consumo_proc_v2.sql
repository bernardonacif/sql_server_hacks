SELECT 
    s.execution_count,
    s.total_worker_time AS TotalWorkerTime,
    s.total_worker_time / s.execution_count AS AvgWorkerTime,
    OBJECT_NAME(qt.objectid, dbid) AS ProcedureName
FROM 
    sys.dm_exec_procedure_stats s
CROSS APPLY 
    sys.dm_exec_sql_text(s.sql_handle) AS qt
ORDER BY 
    s.total_worker_time DESC;
