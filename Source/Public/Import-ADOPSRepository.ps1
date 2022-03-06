function Import-ADOPSRepository {
    [CmdLetBinding(DefaultParameterSetName='RepositoryName')]
    param (
        [Parameter(ParameterSetName = 'RepositoryName')]
        [Parameter(ParameterSetName = 'RepositoryId')]
        $Organization,

        
        [Parameter(Mandatory, ParameterSetName = 'RepositoryName')]
        [Parameter(Mandatory, ParameterSetName = 'RepositoryId')]
        [string]$Project,

        [Parameter(Mandatory, ParameterSetName = 'RepositoryName')]
        [Parameter(Mandatory, ParameterSetName = 'RepositoryId')]
        $GitSource,
        
        [Parameter(Mandatory, ParameterSetName = 'RepositoryId')]
        $RepositoryId,
        
        [Parameter(Mandatory, ParameterSetName = 'RepositoryName')]
        $RepositoryName
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