function Connect-AZDevOPS {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Username,
        
        [Parameter(Mandatory)]
        [string]$PersonalAccessToken,

        [Parameter(Mandatory)]
        [string]$Organization
    )
    
    $Script:AZDevOPSCredentials = [pscredential]::new($Username,(ConvertTo-SecureString -String $PersonalAccessToken -AsPlainText -Force))
    $Script:AzDOOrganization = $Organization

    $URI = "https://vssps.dev.azure.com/${Script:AzDOOrganization}/_apis/profile/profiles/me?api-version=7.1-preview.3"

    InvokeAZDevOPSRestMethod -Method Get -Uri $URI
}