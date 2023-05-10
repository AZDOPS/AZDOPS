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

        if ($PSBoundParameters.ContainsKey('IsDisabled')) {
            $Body.Add('isDisabled',$IsDisabled)
        }

        $InvokeSplat = @{
            URI = $Uri
            Method = 'Patch'
            Body = $Body | ConvertTo-Json -Compress
        }

        InvokeADOPSRestMethod @InvokeSplat
    }
}