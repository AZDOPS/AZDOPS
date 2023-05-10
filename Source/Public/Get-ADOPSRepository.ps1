function Get-ADOPSRepository {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter()]
        [string]$Repository,

        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    if ($PSBoundParameters.ContainsKey('Repository')) {
        $Uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories/$Repository`?api-version=7.1-preview.1"
    }
    else {
        $Uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories?api-version=7.1-preview.1"
    }
    
    $result = InvokeADOPSRestMethod -Uri $Uri -Method Get -Organization $Organization

    if ($result.psobject.properties.name -contains 'value') {
        Write-Output -InputObject $result.value
    }
    else {
        Write-Output -InputObject $result
    }
}