function Get-ADOPSProjectRetentionSettings {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/build/retention?api-version=7.2-preview.1"
    $Settings = InvokeADOPSRestMethod -Uri $Uri -Method Get

    $ResponseHasRetainRunsPerProtectedBranch = $Settings | Get-Member -MemberType NoteProperty | Where-Object Name -eq "retainRunsPerProtectedBranch"
    if ($ResponseHasRetainRunsPerProtectedBranch -and ($null -eq $Settings.retainRunsPerProtectedBranch)) {
        $Settings.retainRunsPerProtectedBranch = [pscustomobject]@{
            min   = [long]0
            max   = [long]50
            value = $null
        }
    }

    Write-Output $Settings
}