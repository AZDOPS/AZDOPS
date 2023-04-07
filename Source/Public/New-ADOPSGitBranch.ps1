function New-ADOPSGitBranch {
    param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Organization,

    [Parameter(Mandatory)]
    [ValidatePattern('^[a-z0-9]{8}\-[a-z0-9]{4}\-[a-z0-9]{4}\-[a-z0-9]{4}\-[a-z0-9]{12}$', ErrorMessage = 'RepositoryId must be in GUID format (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)')]
    [string]$RepositoryId,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Project,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$BranchName,

    [Parameter(Mandatory)]
    [ValidateLength(40,40)]
    [string]$CommitId
    )
    
    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    }
    else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    $Body = @(
        [ordered]@{
            name = "refs/heads/$BranchName"
            oldObjectId = '0000000000000000000000000000000000000000'
            newObjectId = $CommitId
        }
    )
    $Body = ConvertTo-Json -InputObject $Body -Compress

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories/$RepositoryId/refs?api-version=7.1-preview.1"
    $InvokeSplat = @{
        Uri = $Uri
        Method = 'Post'
        Body = $Body
        Organization = $Organization
    }

    InvokeADOPSRestMethod @InvokeSplat
}