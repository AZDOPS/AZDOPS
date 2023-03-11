function Connect-ADOPS {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
    [CmdletBinding(DefaultParameterSetName = 'PAT')]
    param (
        [Parameter(ParameterSetName = 'PAT', Mandatory)]
        [string]$Username,
        
        [Parameter(ParameterSetName = 'PAT', Mandatory)]
        [string]$PersonalAccessToken,

        [Parameter(ParameterSetName = 'PSCredential', Mandatory)]
        [pscredential]$Credential,

        [Parameter(ParameterSetName = 'PSCredential', Mandatory)]
        [Parameter(ParameterSetName = 'PAT', Mandatory)]
        [string]$Organization,

        [Parameter(ParameterSetName = 'PSCredential')]
        [Parameter(ParameterSetName = 'PAT')]
        [switch]$Default
    )
    
    if ($PSCmdlet.ParameterSetName -eq 'PAT') {
        $Credential = [pscredential]::new($Username, (ConvertTo-SecureString -String $PersonalAccessToken -AsPlainText -Force))
    }
    $ShouldBeDefault = $Default.IsPresent

    if ($script:ADOPSCredentials.Count -eq 0) {
        $ShouldBeDefault = $true
        $Script:ADOPSCredentials = @{}
    }
    else {
        $CurrentDefault = $script:ADOPSCredentials.Keys | Where-Object { $ADOPSCredentials[$_].Default -eq $true }
        if ($CurrentDefault -eq $Organization) {
            # If we are overwriting current default it should stay default regardless of -Default parameter.
            $ShouldBeDefault = $true
        }
        elseif ($Default.IsPresent) {
            # We are adding a new default, remove the current.  
            $ADOPSCredentials[$CurrentDefault].Default = $false
        }
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