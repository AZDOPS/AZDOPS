function Get-ADOPSProject {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter()]
        [string]$Project
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    }
    else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    $Uri = "https://dev.azure.com/$Organization/_apis/projects?api-version=7.1-preview.4"

    $Method = 'GET'
    $ProjectInfo = (InvokeADOPSRestMethod -Uri $Uri -Method $Method -Organization $Organization).value

    if (-not [string]::IsNullOrWhiteSpace($Project)) {
        $ProjectInfo = $ProjectInfo | Where-Object -Property Name -eq $Project
    }

    Write-Output $ProjectInfo
}