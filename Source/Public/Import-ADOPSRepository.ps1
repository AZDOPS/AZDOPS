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
        [string]$Organization,

        [Parameter()]
        [switch]$Wait
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
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

    $repoImport = InvokeADOPSRestMethod @InvokeSplat

    if ($PSBoundParameters.ContainsKey('Wait')) {
        # There appears to be a bug in this API where sometimes you don't get the correct status Uri back. Fix it by constructing a correct one instead.
        $verifyUri = "https://dev.azure.com/$Organization/$Project/_apis$($repoImport.url.Split('_apis')[1])"
        while ($repoImport.status -ne 'completed') {
            $repoImport = InvokeADOPSRestMethod -Uri $verifyUri -Method Get
            Start-Sleep -Seconds 1
        }
    }

    $repoImport
}