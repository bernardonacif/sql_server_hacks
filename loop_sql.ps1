# Defina as variáveis do SQL Server e caminho dos arquivos .sql
$SqlServer = "NomeDoSeuServidor"
$Database = "NomeDoSeuBancoDeDados"
$SqlFilesPath = "Caminho\Para\Os\Arquivos\SQL"
$OutputPath = "Caminho\Para\Salvar\Os\Resultados"

# Caminho para o arquivo de log
$LogFilePath = "Caminho\Para\O\Log\log.txt"

# Conecta ao SQL Server
Import-Module SqlServer
$ConnectionString = "Server=$SqlServer;Database=$Database;Integrated Security=True;"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = $ConnectionString
$SqlConnection.Open()

# Loop pelos arquivos .sql na pasta especificada
$SqlFiles = Get-ChildItem -Path $SqlFilesPath -Filter "*.sql"
foreach ($file in $SqlFiles) {
    $sqlQuery = Get-Content $file.FullName -Raw

    # Nome do arquivo .sql para criar o arquivo .txt
    $reportFileName = $file.BaseName + ".txt"
    $reportFilePath = Join-Path -Path $OutputPath -ChildPath $reportFileName

    # Executa a consulta SQL
    $cmd = $SqlConnection.CreateCommand()
    $cmd.CommandText = $sqlQuery
    $result = $cmd.ExecuteReader()

    # Salva os resultados como texto
    $resultText = ""

    while ($result.Read()) {
        $resultText += $result.GetString(0) + "`r`n" # Adiciona cada linha aos resultados
    }

    $resultText | Out-File -FilePath $reportFilePath -Encoding UTF8

    # Log de execução
    Add-content -Path $LogFilePath -Value "Arquivo SQL $file executado e resultado salvo em $reportFileName"
}

# Fecha a conexão com o SQL Server
$SqlConnection.Close()
