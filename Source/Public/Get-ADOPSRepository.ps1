function Get-AZDOPSRepository {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [string]$Project,

        [string]$Repository
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $OrgInfo = GetAZDOPSHeader -Organization $Organization
    }
    else {
        $OrgInfo = GetAZDOPSHeader
        $Organization = $OrgInfo['Organization']
    }

    if ($PSBoundParameters.ContainsKey('Repository')) {
        $Uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories/$Repository`?api-version=7.1-preview.1"
    }
    else {
        $Uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories?api-version=7.1-preview.1"
    }
    
    $result = InvokeAZDOPSRestMethod -Uri $Uri -Method Get -Organization $Organization

    if ($result.psobject.properties.name -contains 'value') {
        Write-Output -InputObject $result.value
    }
    else {
        Write-Output -InputObject $result
    }
}