function Get-ADOPSProject {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Alias('Project')]
        [string]$Name,

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

    if (-not [string]::IsNullOrWhiteSpace($Name)) {
        $ProjectInfo = $ProjectInfo | Where-Object -Property Name -eq $Name
    }

    Write-Output $ProjectInfo
}