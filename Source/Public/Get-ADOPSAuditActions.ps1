function Get-ADOPSAuditActions {
    param (
        [Parameter()]
        [string]$Organization
    )
    
    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    } else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    (InvokeADOPSRestMethod -Uri "https://auditservice.dev.azure.com/$Organization/_apis/audit/actions" -Method Get).value
}