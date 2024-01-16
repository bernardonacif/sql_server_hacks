SELECT TOP 1
    qs.creation_time,
    qs.execution_count,
    qs.total_worker_time AS TotalWorkerTime,
    qs.total_worker_time / qs.execution_count AS AvgWorkerTime,
    SUBSTRING(qt.text, qs.statement_start_offset / 2 + 1, 
        (CASE WHEN qs.statement_end_offset = -1 
              THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2 
              ELSE qs.statement_end_offset 
         END - qs.statement_start_offset) / 2) AS QueryText
FROM
    sys.dm_exec_query_stats qs
CROSS APPLY
    sys.dm_exec_sql_text(qs.sql_handle) AS qt
ORDER BY
    qs.total_worker_time DESC;
