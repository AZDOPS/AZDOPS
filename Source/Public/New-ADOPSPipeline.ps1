function New-ADOPSPipeline {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter(Mandatory)]
        [ValidateScript( { 
            $_ -like '*.yaml' -or
            $_ -like '*.yml'
        },
        ErrorMessage = "Path must be to a yaml file in your repository like: folder/file.yaml or folder/file.yml")] 
        [string]$YamlPath,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Repository,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$FolderPath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines?api-version=7.1-preview.1"

    try {
        $RepositoryID = (Get-ADOPSRepository -Organization $Organization -Project $Project -Repository $Repository -ErrorAction Stop).id
    }
    catch {
        throw "The specified Repository $Repository was not found."
    }

    $Body = [ordered]@{
        "name" = $Name
        "folder" = "\$FolderPath"
        "configuration" = [ordered]@{
            "type" = "yaml"
            "path" = $YamlPath
            "repository" = [ordered]@{
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

    InvokeADOPSRestMethod @InvokeSplat

}