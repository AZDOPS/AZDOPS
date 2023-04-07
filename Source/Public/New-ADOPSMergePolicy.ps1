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
        [Switch]$allowNoFastForward,

        [Parameter()]
        [Switch]$allowSquash,

        [Parameter()]
        [Switch]$allowRebase,

        [Parameter()]
        [Switch]$allowRebaseMerge
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
        allowNoFastForward = $allowNoFastForward.IsPresent
        allowSquash = $allowSquash.IsPresent
        allowRebase = $allowRebase.IsPresent
        allowRebaseMerge = $allowRebaseMerge.IsPresent
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
        Organization = $Organization
    }

    InvokeADOPSRestMethod @InvokeSplat
}