function Get-ADOPSProject {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Project,

        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://dev.azure.com/$Organization/_apis/projects?api-version=7.1-preview.4"

    $Method = 'GET'
    $ProjectInfo = (InvokeADOPSRestMethod -Uri $Uri -Method $Method).value

    if (-not [string]::IsNullOrWhiteSpace($Project)) {
        $ProjectInfo = $ProjectInfo | Where-Object -Property Name -eq $Project
    }

    Write-Output $ProjectInfo
}