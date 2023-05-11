function Remove-ADOPSRepository {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$RepositoryID,

        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories/$RepositoryID`?api-version=7.1-preview.1"
    
    $result = InvokeADOPSRestMethod -Uri $Uri -Method Delete

    if ($result.psobject.properties.name -contains 'value') {
        Write-Output -InputObject $result.value
    }
    else {
        Write-Output -InputObject $result
    }
}