CREATE PROCEDURE sp_who3_light
AS
BEGIN
    SELECT
        r.session_id AS SPID,
        s.login_name AS LoginName,
        r.status AS Status,
        r.command AS Command,
        DB_NAME(r.database_id) AS DatabaseName,
        r.wait_type AS WaitType,
        r.wait_time AS WaitTime,
        r.blocking_session_id AS BlockingSPID,
        r.cpu_time AS CPUTime,
        r.total_elapsed_time AS TotalElapsedTime
    FROM
        sys.dm_exec_requests r
    INNER JOIN
        sys.dm_exec_sessions s ON r.session_id = s.session_id;
END;
