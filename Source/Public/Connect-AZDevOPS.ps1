function Connect-AZDevOPS {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Username,
        
        [Parameter(Mandatory)]
        [string]$PersonalAccessToken
    )
    
    $Script:AZDevOPSCredentials = [pscredential]::new($Username,(ConvertTo-SecureString -String $PersonalAccessToken -AsPlainText -Force))


    $URI = 'https://app.vssps.visualstudio.com/_apis/profile/profiles/me?api-version=7.1-preview.3'

    # Invoke-RestMethod -Method Get -Uri $URI

}