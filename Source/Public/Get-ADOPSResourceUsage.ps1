function Get-ADOPSResourceUsage {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter()]
        [switch]$Force
    )

    if ($script:runInsecureApis -or $Force) {
        # If user didn't specify org, get it from saved context
        if ([string]::IsNullOrEmpty($Organization)) {
            $Organization = GetADOPSDefaultOrganization
        }

        (InvokeADOPSRestMethod -Uri "https://dev.azure.com/$Organization/_apis/ResourceUsage" -Method Get).value
    }
    else {
        Write-Verbose $script:InsecureApisWarning -Verbose
    }

}