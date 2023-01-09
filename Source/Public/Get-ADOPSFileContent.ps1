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

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    } else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    if (-Not $FilePath.StartsWith('/')) {
        $FilePath = $FilePath.Insert(0, '/')
    }

    $UrlEncodedFilePath = [System.Web.HttpUtility]::UrlEncode($FilePath)
    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories/$RepositoryId/items?path=$UrlEncodedFilePath&api-version=7.0"

    InvokeADOPSRestMethod -Uri $Uri -Method Get
}