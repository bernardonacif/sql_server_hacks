-- Usando a tabela information_schema.routines:

USE --DATABASE

GO

SELECT
    ROUTINE_NAME AS ProcedureName,
    ROUTINE_SCHEMA AS SchemaName
FROM
    information_schema.routines
WHERE
    ROUTINE_TYPE = 'PROCEDURE'   -- Filtra apenas procedimentos armazenados
    AND ROUTINE_NAME = 'NomeDaSuaProc';  -- Substitua pelo nome da sua proc

-- Usando a exibição sys.procedures:

USE --DATABASE

GO

SELECT
    name AS ProcedureName,
    SCHEMA_NAME(schema_id) AS SchemaName
FROM
    sys.procedures
WHERE
    type_desc = 'SQL_STORED_PROCEDURE'   -- Filtra apenas procedimentos armazenados
    AND name = 'NomeDaSuaProc';  -- Substitua pelo nome da sua proc
