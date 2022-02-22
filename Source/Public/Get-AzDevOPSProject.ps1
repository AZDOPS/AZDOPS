function Get-AzDevOPSProject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Organization,

        [Parameter()]
        [string]$ProjectName
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetAZDevOPSHeader -Organization $Organization
    }
    else {
        $Org = GetAZDevOPSHeader
    }

    $Uri = "https://dev.azure.com/$($Org['Organization'])/_apis/projects?api-version=7.1-preview.4"

    $Method = 'GET'
    $ProjectInfo = (InvokeAZDevOPSRestMethod -Uri $Uri -Method $Method -Organization $Org['Organization']).value 
    if($ProjectName) {
        $ProjectInfo = $ProjectInfo | Where-Object -Property Name -eq $ProjectName
    }

    $ProjectInfo
}