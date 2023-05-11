function GetADOPSOrganizationAccess {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param (
        [Parameter(Mandatory)]
        [string]$AccountId
    )

    (InvokeADOPSRestMethod -Method GET -Uri "https://app.vssps.visualstudio.com/_apis/accounts?memberId=$AccountId&api-version=7.1-preview.1").value.accountName
}