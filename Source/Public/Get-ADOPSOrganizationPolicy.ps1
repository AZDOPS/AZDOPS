function Get-ADOPSOrganizationPolicy {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter()]
        [ValidateSet(
            'Security',
            'Privacy',
            'ApplicationConnection',
            'User'
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

        $Uri = "https://dev.azure.com/$Organization/_settings/organizationPolicy?__rt=fps&__ver=2"
        $Data = InvokeADOPSRestMethod -Uri $Uri -Method Get
        if ($PSBoundParameters.ContainsKey('PolicyCategory')) {
            switch ($PolicyCategory) {
                'Security' {
                    $Policies = $Data.fps.dataProviders.data.'ms.vss-admin-web.organization-policies-data-provider'.policies.security
                }
                'Privacy' {
                    $Policies = $Data.fps.dataProviders.data.'ms.vss-admin-web.organization-policies-data-provider'.policies.privacy
                }
                'ApplicationConnection' {
                    $Policies = $Data.fps.dataProviders.data.'ms.vss-admin-web.organization-policies-data-provider'.policies.applicationConnection
                }
                'User' {
                    $Policies = $Data.fps.dataProviders.data.'ms.vss-admin-web.organization-policies-data-provider'.policies.user
                }
            }
        }
        else {
            $Policies = $Data.fps.dataProviders.data.'ms.vss-admin-web.organization-policies-data-provider'.policies.psobject.Properties.name | ForEach-Object {
                $Data.fps.dataProviders.data.'ms.vss-admin-web.organization-policies-data-provider'.policies.$_.policy
            }
        }

        Write-Output $Policies
    }
    else {
        Write-Verbose $script:InsecureApisWarning -Verbose
    }

}