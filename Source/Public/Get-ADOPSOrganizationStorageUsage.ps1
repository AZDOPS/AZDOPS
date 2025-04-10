function Get-ADOPSOrganizationStorageUsage {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$MeterId = '3efc2e47-d73e-4213-8368-3a8723ceb1cc'
    )
    
    $OrganizationId = (Get-ADOPSOrganizationAdminOverview).avatarUrl.split('/')[-2]
    
    InvokeADOPSRestMethod -Uri "https://azdevopscommerce.dev.azure.com/$OrganizationId/_apis/AzComm/MeterUsage2/$MeterId" -Method Get

}