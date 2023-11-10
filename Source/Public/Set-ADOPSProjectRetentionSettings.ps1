function Set-ADOPSProjectRetentionSettings {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        $Values
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/build/retention?api-version=7.2-preview.1"
    $Body = $Values | ConvertTo-Json
    Write-Debug $Body
    $Settings = InvokeADOPSRestMethod -Uri $Uri -Method Patch -Body $Body
    Write-Debug ($Settings | ConvertTo-Json)

    $ValuesHasRetainRunsPerProtectedBranch = $Values | Get-Member -MemberType NoteProperty | Where-Object Name -eq "retainRunsPerProtectedBranch"
    $ResponseHasRetainRunsPerProtectedBranch = $Settings | Get-Member -MemberType NoteProperty | Where-Object Name -eq "retainRunsPerProtectedBranch"
    if ($ResponseHasRetainRunsPerProtectedBranch -and ($null -eq $Settings.retainRunsPerProtectedBranch)) {
        if ($ValuesHasRetainRunsPerProtectedBranch) {
            $settings.retainRunsPerProtectedBranch = [pscustomobject]@{
                min   = [long] 0
                max   = [long] 50
                value = $Values.retainRunsPerProtectedBranch.value
            }
        }
        else {
            $settings.retainRunsPerProtectedBranch = [pscustomobject]@{
                min   = [long] 0
                max   = [long] 50
                value = $null
            }
        }
    }
    
    Write-Output $Settings
}