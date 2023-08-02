CREATE TABLE #ColunasVerificar (
    TableName NVARCHAR(128),
    ColumnName NVARCHAR(128),
    ColExists BIT
);

INSERT INTO #ColunasVerificar (TableName, ColumnName)
VALUES
    ('Tabela1', 'Coluna1'),
    ('Tabela1', 'Coluna2'),
    ('Tabela2', 'Coluna3'),
    -- Adicione mais linhas conforme necessário para verificar outras colunas em outras tabelas
    -- ('OutraTabela', 'OutraColuna')
;

DECLARE @Sql NVARCHAR(MAX);

SET @Sql = N'
UPDATE #ColunasVerificar
SET ColExists = 0;

';

-- Execute a consulta para verificar cada coluna
DECLARE @TableName NVARCHAR(128), @ColumnName NVARCHAR(128);
DECLARE column_cursor CURSOR FOR
SELECT TableName, ColumnName FROM #ColunasVerificar;

OPEN column_cursor;
FETCH NEXT FROM column_cursor INTO @TableName, @ColumnName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Sql += N'
    BEGIN TRY
        EXEC(''SELECT TOP 1 ' + QUOTENAME(@ColumnName) + ' FROM ' + QUOTENAME(@TableName) + ''');
        UPDATE #ColunasVerificar SET ColExists = 1 WHERE TableName = ''' + @TableName + ''' AND ColumnName = ''' + @ColumnName + ''';
    END TRY
    BEGIN CATCH
        UPDATE #ColunasVerificar SET ColExists = 0 WHERE TableName = ''' + @TableName + ''' AND ColumnName = ''' + @ColumnName + ''';
    END CATCH;
    ';
    
    FETCH NEXT FROM column_cursor INTO @TableName, @ColumnName;
END

CLOSE column_cursor;
DEALLOCATE column_cursor;

EXEC sp_executesql @Sql;

SELECT * FROM #ColunasVerificar;

DROP TABLE #ColunasVerificar;
