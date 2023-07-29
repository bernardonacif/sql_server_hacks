BEGIN TRY
    -- Select 1
    SELECT Coluna1 FROM Tabela1;

    -- Select 2
    SELECT Coluna2 FROM Tabela2;

    -- Select 3
    SELECT Coluna3 FROM Tabela3;

    -- Adicione os outros 47 selects aqui

END TRY
BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(1000);
    SET @ErrorMessage = ERROR_MESSAGE();

    PRINT 'Erro: ' + @ErrorMessage;
END CATCH;
