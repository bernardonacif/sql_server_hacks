-- Declarar variáveis
DECLARE @DatabaseName NVARCHAR(128)
DECLARE @SQLCommand NVARCHAR(MAX)

-- Declarar tabela temporária para armazenar os resultados
CREATE TABLE #TempPermissions (
    DatabaseName NVARCHAR(128),
    LoginName NVARCHAR(128),
    LoginType NVARCHAR(128),
    Permission NVARCHAR(128),
    State NVARCHAR(128),
    ObjectName NVARCHAR(128),
    SchemaName NVARCHAR(128)
)

-- Declarar cursor para iterar por todos os bancos de dados
DECLARE db_cursor CURSOR FOR
SELECT name 
FROM sys.databases 
WHERE state_desc = 'ONLINE' AND name NOT IN ('master', 'tempdb', 'model', 'msdb')

-- Abrir cursor
OPEN db_cursor

-- Loop para iterar por todos os bancos de dados
FETCH NEXT FROM db_cursor INTO @DatabaseName
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Construir o comando SQL para cada banco de dados
    SET @SQLCommand = 
    'USE [' + @DatabaseName + '];
    INSERT INTO #TempPermissions
    SELECT 
        ''' + @DatabaseName + ''' AS DatabaseName,
        princ.name AS LoginName,
        princ.type_desc AS LoginType,
        perm.permission_name AS Permission,
        perm.state_desc AS State,
        OBJECT_NAME(perm.major_id) AS ObjectName,
        sch.name AS SchemaName
    FROM 
        sys.server_principals princ
    LEFT JOIN 
        sys.server_permissions perm ON princ.principal_id = perm.grantee_principal_id
    LEFT JOIN 
        sys.schemas sch ON sch.schema_id = perm.major_id
    WHERE 
        princ.type_desc IN (''SQL_LOGIN'', ''WINDOWS_LOGIN'', ''WINDOWS_GROUP'')
        AND princ.name NOT LIKE ''##%'' -- exclui logins do sistema
    ORDER BY 
        LoginName, Permission, ObjectName;'

    -- Executar o comando SQL
    EXEC sp_executesql @SQLCommand

    -- Próximo banco de dados
    FETCH NEXT FROM db_cursor INTO @DatabaseName
END

-- Fechar cursor
CLOSE db_cursor
DEALLOCATE db_cursor

-- Selecionar os resultados da tabela temporária
SELECT * FROM #TempPermissions

-- Drop tabela temporária
DROP TABLE #TempPermissions
