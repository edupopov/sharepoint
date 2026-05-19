# Install-Module -Name Microsoft.Online.SharePoint.PowerShell
# Update-Module -Name Microsoft.Online.SharePoint.PowerShell
# connect-SPOservice -Url https://EMPRESA-admin.sharepoint.com


# 10 GB em MB
$Quota = 10240

Get-SPOSite -Limit All | Where-Object {
    $_.Template -ne "SPSPERS" -and
    $_.StorageUsageCurrent -lt $Quota
} | Select-Object Url, @{
    Name="UsageGB";
    Expression={[math]::Round($_.StorageUsageCurrent / 1024, 2)}
} | Sort-Object UsageGB -Descending

