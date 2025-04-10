function Get-ADOPSOrganizationAdvancedSecurity {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://advsec.dev.azure.com/$Organization/_apis/Management/enablement"

    (InvokeADOPSRestMethod -Uri $Uri -Method Get)
}