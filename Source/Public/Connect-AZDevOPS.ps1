function Connect-AZDevOPS {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Username,
        
        [Parameter(Mandatory)]
        [string]$PersonalAccessToken,

        [Parameter(Mandatory)]
        [string]$Organization,

        [Parameter()]
        [switch]$Default
    )
    
    $Credential = [pscredential]::new($Username, (ConvertTo-SecureString -String $PersonalAccessToken -AsPlainText -Force))
    $ShouldBeDefault = $Default.IsPresent

    if ($AZDevOPSCredentials.Count -eq 0) {
        $ShouldBeDefault = $true
        $Script:AZDevOPSCredentials = @{}
    }
    elseif ($default.IsPresent) {
        $r = $script:AZDevOPSCredentials.Keys | Where-Object { $AZDevOPSCredentials[$_].Default -eq $true }
        $AZDevOPSCredentials[$r].Default = $false
    }

    $OrgData = @{
        Credential = $Credential
        Default    = $ShouldBeDefault
    }
    
    $Script:AZDevOPSCredentials[$Organization] = $OrgData
    
    $URI = "https://vssps.dev.azure.com/$Organization/_apis/profile/profiles/me?api-version=7.1-preview.3"

    try {
        InvokeAZDevOPSRestMethod -Method Get -Uri $URI
    }
    catch {
        $Script:AZDevOPSCredentials.Remove($Organization)
        throw $_
    }
}