function Get-ADOPSFileContent {
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter(Mandatory)]
        [string]$RepositoryId,

        [Parameter(Mandatory)]
        [string]$FilePath
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    if (-Not $FilePath.StartsWith('/')) {
        $FilePath = $FilePath.Insert(0, '/')
    }

    $UrlEncodedFilePath = [System.Web.HttpUtility]::UrlEncode($FilePath)
    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories/$RepositoryId/items?path=$UrlEncodedFilePath&api-version=7.1-preview.1"

    InvokeADOPSRestMethod -Uri $Uri -Method Get
}