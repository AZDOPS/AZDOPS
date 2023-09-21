function New-ADOPSMergePolicy {
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

        [Parameter()]
        [Switch]$AllowNoFastForward,

        [Parameter()]
        [Switch]$AllowSquash,

        [Parameter()]
        [Switch]$AllowRebase,

        [Parameter()]
        [Switch]$AllowRebaseMerge
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
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
        allowNoFastForward = $AllowNoFastForward.IsPresent
        allowSquash = $AllowSquash.IsPresent
        allowRebase = $AllowRebase.IsPresent
        allowRebaseMerge = $AllowRebaseMerge.IsPresent
    }


    $Body = [ordered]@{
        type = [ordered]@{
            id = "fa4e907d-c16b-4a4c-9dfa-4916e5d171ab" 
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