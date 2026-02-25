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
        
        if ($PSBoundParameters.ContainsKey('PolicyCategory')) {
            switch ($PolicyCategory) {

                # Restrict global personal access token creation
                'RestrictGlobalPersonalAccessToken' {
                    $Uri = "https://vssps.dev.azure.com/$Organization/_apis/TenantPolicy/Policies/TenantPolicy.RestrictGlobalPersonalAccessToken"
                }

                # Enforce maximum personal access token lifespan
                'RestrictPersonalAccessTokenLifespan' {
                    # Properties.MaxPatLifespanInDays if True
                    $Uri = "https://vssps.dev.azure.com/$Organization/_apis/TenantPolicy/Policies/TenantPolicy.RestrictPersonalAccessTokenLifespan"
                }

                # Automatically revoke leaked personal access tokens
                'EnableLeakedPersonalAccessTokenAutoRevocation' {
                    $Uri = "https://vssps.dev.azure.com/$Organization/_apis/TenantPolicy/Policies/TenantPolicy.EnableLeakedPersonalAccessTokenAutoRevocation"
                }

                # Restrict organization creation
                'OrganizationCreationRestriction' {
                    $Uri = "https://vssps.dev.azure.com/$Organization/_apis/TenantPolicy/Policies/TenantPolicy.OrganizationCreationRestriction"
                }

                # Restrict full-scoped personal access token creation
                'RestrictFullScopePersonalAccessToken' {
                    $Uri = "https://vssps.dev.azure.com/$Organization/_apis/TenantPolicy/Policies/TenantPolicy.RestrictFullScopePersonalAccessToken"
                }
            }
            $Data = InvokeADOPSRestMethod -Uri $Uri -Method Get
            Write-Output $Data
        }
        else {
            @('RestrictGlobalPersonalAccessToken', 'RestrictPersonalAccessTokenLifespan', 'EnableLeakedPersonalAccessTokenAutoRevocation', 'OrganizationCreationRestriction', 'RestrictFullScopePersonalAccessToken') | ForEach-Object {
                InvokeADOPSRestMethod -Uri "https://vssps.dev.azure.com/$Organization/_apis/TenantPolicy/Policies/TenantPolicy.$_" -Method Get
            }
        }
    }
    else {
        Write-Verbose $script:InsecureApisWarning -Verbose
    }
}