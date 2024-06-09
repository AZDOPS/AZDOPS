function New-ADOPSGitFile {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,
        
        [Parameter(Mandatory)]
        [string]$Project,
        
        [Parameter(Mandatory)]
        [string]$Repository,
        
        [Parameter(Mandatory)]
        [string]$File,
        
        [Parameter()]
        [string]$FileName,
        
        [Parameter()]
        [string]$Path,
        
        [Parameter()]
        [string]$CommitMessage = 'File added using the ADOPS PowerShell module'
    )

    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }
    
    if ([string]::IsNullOrEmpty($Path)) {
        $Path = '/'
    }

    if ([string]::IsNullOrEmpty($FileName)) {
        $FileName = (Get-Item -Path $File).Name
    }

    $newFilePath = "/${Path}/$FileName" -replace '/{2,}','/' # Make sure there are never two or more slashes in a row.

    $repoDetails = Get-ADOPSRepository -Project $Project -Repository $Repository

    $refIduri = "$($repoDetails.url)/refs?filter=$($repoDetails.defaultBranch -replace '^refs/','')&includeStatuses=true&latestStatusesOnly=true&api-version=7.2-preview.2"
    $refId = InvokeADOPSRestMethod -Uri $refIduri -Method Get | Select-Object -ExpandProperty value
    
    $body = [ordered]@{
        refUpdates = @(
            [ordered]@{
                name        = $repoDetails.defaultBranch
                oldObjectId = $refId.objectId
            }
        )
        commits    = @(
            [ordered]@{
                comment = $CommitMessage
                changes = @(
                    [ordered]@{
                        changeType = "add"
                        item       = [ordered]@{
                            path = $newFilePath
                        }
                        newContent = [ordered]@{
                            content     = $(Get-Content $File -Raw)
                            contentType = "rawtext"
                        }
                    }
                )
            }
        )
    } | ConvertTo-Json -Depth 100 -Compress

    $Uri = "$($repoDetails.url)/pushes?api-version=7.2-preview.3"
    $InvokeSplat = @{
        Method = 'Post'
        Uri = $Uri
        Body = $Body
    }
    
    InvokeADOPSRestMethod @InvokeSplat
}