function Get-ADOPSAuditStreams {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    (InvokeADOPSRestMethod -Uri "https://auditservice.dev.azure.com/$Organization/_apis/audit/streams?api-version=7.2-preview.1" -Method Get).value
}