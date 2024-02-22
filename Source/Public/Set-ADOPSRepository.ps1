function Set-ADOPSRepository {
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$RepositoryId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$DefaultBranch,

        [Parameter()]
        [bool]$IsDisabled,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$NewName
    )

    if ( ([string]::IsNullOrEmpty($DefaultBranch)) -and ([string]::IsNullOrEmpty($NewName)) -and (-Not $PSBoundParameters.ContainsKey('IsDisabled')) ) {
        # Nothing to do, exit early
    }
    else {
        # If user didn't specify org, get it from saved context
        if ([string]::IsNullOrEmpty($Organization)) {
            $Organization = GetADOPSDefaultOrganization
        }
        
        $URI = "https://dev.azure.com/${Organization}/${Project}/_apis/git/repositories/${RepositoryId}?api-version=7.1-preview.1"
        
        $InvokeSplat = @{
            URI = $Uri
            Method = 'Patch'
        }

        if ($PSBoundParameters.ContainsKey('IsDisabled') -and ($false -eq $IsDisabled)) {
            # Enabling a repo needs to be done in a separate call before changing any other settings.
            $Body = [ordered]@{
                'isDisabled' = $IsDisabled
            }
            $InvokeSplat.Body = $Body | ConvertTo-Json -Compress
            try {
                InvokeADOPSRestMethod @InvokeSplat
            }
            catch {
                if (($_.ErrorDetails.Message | ConvertFrom-Json).message -eq 'The repository change is not supported.') {
                    Write-Warning 'Failed to enable the repo. This is most likely because it is already enabled.'
                }
                else {
                    throw $_
                }
            }
        }

        $Body = [ordered]@{}

        if (-Not [string]::IsNullOrEmpty($NewName)) {
            $Body.Add('name',$NewName)
        }

        if (-Not [string]::IsNullOrEmpty($DefaultBranch)) {
            if (-Not ($DefaultBranch -match '^\w+/\w+/\w+$')) {
                $DefaultBranch = "refs/heads/$DefaultBranch"
            }
            $Body.Add('defaultBranch',$DefaultBranch)
        }

        if ($body.Keys.Count -gt 0) {
            $InvokeSplat.Body = $Body | ConvertTo-Json -Compress
            try {
                InvokeADOPSRestMethod @InvokeSplat
            }
            catch {
                if (($_.ErrorDetails.Message | ConvertFrom-Json).message -like "TF401019*") {
                    Write-Warning 'Failed to update the repo. This may happen if the repo is disabled. Make sure it is enabled, or add -IsDisabled:$false'
                }
                else {
                    throw $_
                }
            }
        }
        
        if ($PSBoundParameters.ContainsKey('IsDisabled') -and ($true -eq $IsDisabled)) {
            # Disabling a repo needs to be done in a separate call and after any other changes.
            $Body = [ordered]@{
                'isDisabled' = $IsDisabled
            }
            $InvokeSplat.Body = $Body | ConvertTo-Json -Compress
            try {
                InvokeADOPSRestMethod @InvokeSplat
            }
            catch {
                if (($_.ErrorDetails.Message | ConvertFrom-Json).message -eq 'The repository change is not supported.') {
                    Write-Warning 'Failed to disable the repo. This is most likely because it is already disabled.'
                }
                else {
                    throw $_
                }
            }
        }
    }
}