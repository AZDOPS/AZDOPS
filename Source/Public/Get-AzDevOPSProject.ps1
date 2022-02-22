function Get-AzDevOPSProject {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter()]
        [string]$ProjectName
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetAZDevOPSHeader -Organization $Organization
    }
    else {
        $Org = GetAZDevOPSHeader
        $Organization = $Org['Organization']
    }

    $Uri = "https://dev.azure.com/$Organization/_apis/projects?api-version=7.1-preview.4"

    $Method = 'GET'
    $ProjectInfo = (InvokeAZDevOPSRestMethod -Uri $Uri -Method $Method -Organization $Organization).value

    if (-not [string]::IsNullOrWhiteSpace($ProjectName)) {
        $ProjectInfo = $ProjectInfo | Where-Object -Property Name -eq $ProjectName
    }

    Write-Output $ProjectInfo
}