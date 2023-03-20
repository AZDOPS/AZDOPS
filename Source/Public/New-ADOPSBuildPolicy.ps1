function New-ADOPSBuildPolicy {
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$RepositoryId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Branch,

        [Parameter(Mandatory)]
        [int]$PipelineId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Displayname,

        [Parameter()]
        [string[]]$filenamePatterns
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    }
    else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    if (-Not ($Branch -match '^\w+/\w+/\w+$')) {
        $Branch = "refs/heads/$Branch"
    }
    $GitBranchRef = $Branch

    $settings = [ordered]@{
        scope = @(
            [ordered]@{
                repositoryId = $RepositoryId
                refName = $GitBranchRef
                matchKind = "exact"
            }
        )
        buildDefinitionId = $PipelineId.ToString()
        queueOnSourceUpdateOnly = $false
        manualQueueOnly = $false
        displayName = $Displayname
        validDuration = "0"
    }

    if ($filenamePatterns.Count -gt 0) {
        $settings.Add('filenamePatterns', $filenamePatterns)
    }

    $Body = [ordered]@{
        type = [ordered]@{
            id = "0609b952-1397-4640-95ec-e00a01b2c241" 
        }
        isBlocking = $true
        isEnabled = $true
        settings = $settings
    } 
    
    $Body = $Body | ConvertTo-Json -Depth 10 -Compress
    
    $InvokeSplat = @{
        Uri = "https://dev.azure.com/$Organization/$Project/_apis/policy/configurations?api-version=7.1-preview.1"
        Method = 'POST'
        Body = $Body
    }

    InvokeADOPSRestMethod @InvokeSplat
}