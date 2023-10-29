SELECT COUNT(DISTINCT coluna_fgts) AS ContagemDistinta
FROM sua_tabela
WHERE data_hora >= CONVERT(DATETIME, CONVERT(VARCHAR(10), GETDATE(), 101) + ' 18:00:00', 101)
  AND data_hora <= GETDATE();
