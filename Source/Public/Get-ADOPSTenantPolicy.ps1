function Get-ADOPSTenantPolicy {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter()]
        [ValidateSet(
            'RestrictGlobalPersonalAccessToken',
            'RestrictPersonalAccessTokenLifespan',
            'EnableLeakedPersonalAccessTokenAutoRevocation',
            'OrganizationCreationRestriction',
            'RestrictFullScopePersonalAccessToken'
        )]
        [string]
        $PolicyCategory,

        [Parameter()]
        [switch]$Force
    )

    if ($script:runInsecureApis -or $Force) {
        # If user didn't specify org, get it from saved context
        if ([string]::IsNullOrEmpty($Organization)) {
            $Organization = GetADOPSDefaultOrganization
        }
        
        $Uri = "https://vssps.dev.azure.com/$Organization/_apis/TenantPolicy/Policies/TenantPolicy"
        if ($PSBoundParameters.ContainsKey('PolicyCategory')) {
            [string[]]$getList = $PolicyCategory
        }
        else {
            [string[]]$getList  = @('RestrictGlobalPersonalAccessToken', 'RestrictPersonalAccessTokenLifespan', 'EnableLeakedPersonalAccessTokenAutoRevocation', 'OrganizationCreationRestriction', 'RestrictFullScopePersonalAccessToken')
        }

        foreach ($policy in $getList) {
            InvokeADOPSRestMethod -Uri ("$Uri.$policy") -Method Get
        }
    }
    else {
        Write-Verbose $script:InsecureApisWarning -Verbose
    }
}