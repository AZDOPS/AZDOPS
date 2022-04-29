function Connect-ADOPS {
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

    if ($script:ADOPSCredentials.Count -eq 0) {
        $ShouldBeDefault = $true
        $Script:ADOPSCredentials = @{}
    }
    elseif ($default.IsPresent) {
        $r = $script:ADOPSCredentials.Keys | Where-Object { $ADOPSCredentials[$_].Default -eq $true }
        $ADOPSCredentials[$r].Default = $false
    }

    $OrgData = @{
        Credential = $Credential
        Default    = $ShouldBeDefault
    }
    
    $Script:ADOPSCredentials[$Organization] = $OrgData
    
    $URI = "https://vssps.dev.azure.com/$Organization/_apis/profile/profiles/me?api-version=7.1-preview.3"

    try {
        InvokeADOPSRestMethod -Method Get -Uri $URI
    }
    catch {
        $Script:ADOPSCredentials.Remove($Organization)
        throw $_
    }
}