SELECT name AS NomeTrigger,
       type_desc AS Tipo
FROM sys.triggers
WHERE OBJECT_NAME(parent_object_id) = 'NomeDaTabela'; -- Substitua pelo nome da tabela
