SELECT OBJECT_NAME(parent_object_id) AS Tabela,
       name AS NomeTrigger,
       type_desc AS Tipo,
       OBJECT_DEFINITION(object_id) AS Definicao
FROM sys.triggers
WHERE OBJECT_NAME(parent_object_id) = 'NomeDaTabela' -- Substitua pelo nome da tabela
      AND name = 'NomeDaTrigger'; -- Substitua pelo nome da trigger
