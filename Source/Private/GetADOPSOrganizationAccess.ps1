function GetADOPSOrganizationAccess {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param (
        [Parameter(Mandatory)]
        [string]$AccountId,
        
        [Parameter()]
        [string]$Token
    )

    (InvokeADOPSRestMethod -Method GET -Token $Token -Uri "https://app.vssps.visualstudio.com/_apis/accounts?memberId=$AccountId&api-version=7.1-preview.1").value.accountName
}