function Get-AZDOPSProject {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter()]
        [string]$ProjectName
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetAZDOPSHeader -Organization $Organization
    }
    else {
        $Org = GetAZDOPSHeader
        $Organization = $Org['Organization']
    }

    $Uri = "https://dev.azure.com/$Organization/_apis/projects?api-version=7.1-preview.4"

    $Method = 'GET'
    $ProjectInfo = (InvokeAZDOPSRestMethod -Uri $Uri -Method $Method -Organization $Organization).value

    if (-not [string]::IsNullOrWhiteSpace($ProjectName)) {
        $ProjectInfo = $ProjectInfo | Where-Object -Property Name -eq $ProjectName
    }

    Write-Output $ProjectInfo
}