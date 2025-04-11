function Get-ADOPSOrganizationRepositorySettings {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://dev.azure.com/$Organization/_api/_versioncontrol/AllGitRepositoriesOptions?__v=5"

    (InvokeADOPSRestMethod -Uri $Uri -Method Get).__wrappedArray

}