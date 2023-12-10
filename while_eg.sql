declare @hoje as DATETIME
declare @data_sistema as DATETIME

set @hoje = GETDATE()
set @data_sistema = (SELECT DATA_SISTEMA FROM ESTUDOS..DATA_DIA)

WHILE @hoje > @data_sistema
    BEGIN
        if @hoje <> @data_sistema
            BEGIN
                UPDATE ESTUDOS..DATA_DIA SET DATA_SISTEMA = DATEADD(day, 1, DATA_SISTEMA)
                PRINT 'data atualizada para ' + cast(@data_sistema as VARCHAR(30))
            END
            
        ELSE
            BEGIN
                PRINT 'nao é necessario a atualizacao da data'
            END
    END



