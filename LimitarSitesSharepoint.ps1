# Script que valida se o site possui um determnado espaço em disco, inderior a 10gb
# Depois configura a cota para 15gb e alerta para 97%
# A validação e configuração é feita site a site
# Criado por Eduardo Popovici

# Conectar no Tenant e autenticar
# $AdminUrl = "https://EMPRESA-admin.sharepoint.com"
# Connect-SPOService -Url $AdminUrl

# Definições de busca
# Criação de variaveis
$UsageThreshold = 10240   # 10 GB
$Quota = 15360           # 15 GB
$Warning = 97

# validação e aplicação de configurações
Get-SPOSite -Limit All | Where-Object { $_.Template -ne "SPSPERS" } | ForEach-Object {

    $Site = $_

    # Validação individual
    if ($Site.StorageUsageCurrent -le $UsageThreshold) {

        Set-SPOSite -Identity $Site.Url `
            -StorageQuota $Quota `
            -StorageQuotaWarningLevel ($Quota * ($Warning/100))

        Write-Output "OK: $($Site.Url) | Uso: $([math]::Round($Site.StorageUsageCurrent/1024,2)) GB"

    } else {

        Write-Output "IGNORADO: $($Site.Url) | Uso: $([math]::Round($Site.StorageUsageCurrent/1024,2)) GB"
    }
}
