function Import-ADOPSRepository {
    [CmdLetBinding(DefaultParameterSetName='RepositoryName')]
    param (
        [Parameter(Mandatory)]
        [string]$GitSource,

        [Parameter(Mandatory, ParameterSetName = 'RepositoryId')]
        [string]$RepositoryId,
        
        [Parameter(Mandatory, ParameterSetName = 'RepositoryName')]
        [string]$RepositoryName,

        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter()]
        [string]$Organization
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $OrgInfo = GetADOPSHeader -Organization $Organization
    }
    else {
        $OrgInfo = GetADOPSHeader
        $Organization = $OrgInfo['Organization']
    }

    switch ($PSCmdlet.ParameterSetName) {
        'RepositoryName' { $RepoIdentifier = $RepositoryName}
        'RepositoryId'   { $RepoIdentifier = $RepositoryId}
        Default {}
    }
    $InvokeSplat = @{
        URI = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories/$RepoIdentifier/importRequests?api-version=7.1-preview.1"
        Method = 'Post'
        Body = "{""parameters"":{""gitSource"":{""url"":""$GitSource""}}}"
        Organization = $Organization
    }

    InvokeADOPSRestMethod @InvokeSplat
}