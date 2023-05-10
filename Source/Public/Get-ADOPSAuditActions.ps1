function Get-ADOPSAuditActions {
    param (
        [Parameter()]
        [string]$Organization
    )
    
    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    (InvokeADOPSRestMethod -Uri "https://auditservice.dev.azure.com/$Organization/_apis/audit/actions" -Method Get).value
}