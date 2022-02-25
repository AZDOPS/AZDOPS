function New-AZDOPSPipeline {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter(Mandatory)]
        [ValidateScript( { $_ -like '*.yaml' },
        ErrorMessage = "Path must be to a yaml file in your repository like: folder/file.yaml")] 
        [string]$YamlPath,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Repository,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$PipelineGroupFolder,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $OrgInfo = GetAZDOPSHeader -Organization $Organization
    }
    else {
        $OrgInfo = GetAZDOPSHeader
        $Organization = $OrgInfo['Organization']
    }

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines?api-version=7.1-preview.1"

    try {
        $RepositoryID = (Get-AZDOPSRepository -Organization $Organization -Project $Project -Repository $Repository -ErrorAction Stop).id
    }
    catch {
        throw "The specified Repository $Repository was not found."
    }

    $Body = @{
        "name" = $Name
        "folder" = "\$PipelineGroupFolder"
        "configuration" = @{
            "type" = "yaml"
            "path" = $YamlPath
            "repository" = @{
                "id" = $RepositoryID
                "type" = "azureReposGit"
            }
        }
    }
    $Body = $Body | ConvertTo-Json -Compress

    $InvokeSplat = @{
        Method       = 'Post'
        Uri          = $URI
        Organization = $Organization
        Body         = $Body 
    }

    InvokeAZDOPSRestMethod @InvokeSplat

}