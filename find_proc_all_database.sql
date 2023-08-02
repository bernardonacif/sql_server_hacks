DECLARE @ProcName NVARCHAR(128) = 'NomeDaSuaProc'; -- Substitua pelo nome da sua proc

CREATE TABLE #ProcInfo (
    DatabaseName NVARCHAR(128),
    SchemaName NVARCHAR(128),
    ProcedureName NVARCHAR(128)
);

DECLARE @DBName NVARCHAR(128);
DECLARE @SQL NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE database_id > 4; -- Exclui bancos de sistema

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DBName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = N'
    USE ' + QUOTENAME(@DBName) + ';
    INSERT INTO #ProcInfo (DatabaseName, SchemaName, ProcedureName)
    SELECT
        ' + QUOTENAME(@DBName, '''') + ',
        SCHEMA_NAME(schema_id),
        name
    FROM
        ' + QUOTENAME(@DBName) + '.sys.procedures
    WHERE
        type_desc = ''SQL_STORED_PROCEDURE''
        AND name = ' + QUOTENAME(@ProcName, '''') + ';
    ';

    EXEC sp_executesql @SQL;

    FETCH NEXT FROM db_cursor INTO @DBName;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;

SELECT * FROM #ProcInfo;

DROP TABLE #ProcInfo;
