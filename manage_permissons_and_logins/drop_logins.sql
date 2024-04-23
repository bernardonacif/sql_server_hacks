-- Declarar variáveis
DECLARE @LoginName NVARCHAR(128)
DECLARE @DatabaseName NVARCHAR(128)
DECLARE @SQLCommand NVARCHAR(MAX)

-- Definir o nome do login que você deseja excluir
SET @LoginName = '' -- insert login

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
    SET @SQLCommand = 'USE [' + @DatabaseName + ']; DROP LOGIN [' + @LoginName + '];'

    -- Executar o comando SQL
    BEGIN TRY
        EXEC sp_executesql @SQLCommand
        PRINT 'Login ' + @LoginName + ' excluído do banco de dados ' + @DatabaseName
    END TRY
    BEGIN CATCH
        PRINT 'Erro ao excluir o login ' + @LoginName + ' do banco de dados ' + @DatabaseName + ': ' + ERROR_MESSAGE()
    END CATCH

    -- Próximo banco de dados
    FETCH NEXT FROM db_cursor INTO @DatabaseName
END

-- Fechar cursor
CLOSE db_cursor
DEALLOCATE db_cursor
