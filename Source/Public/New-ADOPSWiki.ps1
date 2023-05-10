function New-ADOPSWiki {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$WikiName,
        
        [Parameter(Mandatory)]
        [string]$WikiRepository,

        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter()]
        [string]$WikiRepositoryPath = '/',
        
        [Parameter()]
        [string]$GitBranch = 'main',

        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $ProjectId = (Get-ADOPSProject -Project $Project).id
    $RepositoryId = (Get-ADOPSRepository -Project $Project -Repository $WikiRepository).id

    $URI = "https://dev.azure.com/$Organization/_apis/wiki/wikis?api-version=7.1-preview.2"
    
    $Method = 'Post'
    $Body = [ordered]@{
        'type' = 'codeWiki'
        'name' = $WikiName
        'projectId' = $ProjectId
        'repositoryId' = $RepositoryId
        'mappedPath' = $WikiRepositoryPath
        'version' = @{'version' = $GitBranch}
    } 

    $InvokeSplat = @{
        Uri = $URI
        Method = $Method
        Body = $Body | ConvertTo-Json -Compress
    }

    InvokeADOPSRestMethod @InvokeSplat
}