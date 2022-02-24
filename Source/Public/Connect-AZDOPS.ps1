function Connect-AZDOPS {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
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

    if ($AZDOPSCredentials.Count -eq 0) {
        $ShouldBeDefault = $true
        $Script:AZDOPSCredentials = @{}
    }
    elseif ($default.IsPresent) {
        $r = $script:AZDOPSCredentials.Keys | Where-Object { $AZDOPSCredentials[$_].Default -eq $true }
        $AZDOPSCredentials[$r].Default = $false
    }

    $OrgData = @{
        Credential = $Credential
        Default    = $ShouldBeDefault
    }
    
    $Script:AZDOPSCredentials[$Organization] = $OrgData
    
    $URI = "https://vssps.dev.azure.com/$Organization/_apis/profile/profiles/me?api-version=7.1-preview.3"

    try {
        InvokeAZDOPSRestMethod -Method Get -Uri $URI
    }
    catch {
        $Script:AZDOPSCredentials.Remove($Organization)
        throw $_
    }
}