function Get-ADOPSOrganizationCommerceMeterUsage {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter()]
        [string]$MeterId
    )
    
    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }


    $AccountId = (InvokeADOPSRestMethod -Method GET -Uri 'https://app.vssps.visualstudio.com/_apis/profile/profiles/me?api-version=7.1-preview.3').publicAlias
    
    # GetADOPSOrganizationAccess could have been used instead.
    # However it requires token and only returns accountName

    # Get available orgs
    $Orgs = (InvokeADOPSRestMethod -Method GET -Uri "https://app.vssps.visualstudio.com/_apis/accounts?memberId=$AccountId&api-version=7.1-preview.1").value
    
    $OrganizationId = ($Orgs | Where-object accountName -eq $Organization).AccountId
    
    if ($PSBoundParameters.ContainsKey('MeterId')) {
        InvokeADOPSRestMethod -Uri "https://azdevopscommerce.dev.azure.com/$OrganizationId/_apis/AzComm/MeterUsage2/$MeterId" -Method Get
    }
    else {
        (InvokeADOPSRestMethod -Uri "https://azdevopscommerce.dev.azure.com/$OrganizationId/_apis/AzComm/MeterUsage2" -Method Get).value
    }

}