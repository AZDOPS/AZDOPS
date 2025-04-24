function Get-ADOPSOrganizationAdminOverview {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter()]
        [string[]]
        $ContributionIds = @("ms.vss-admin-web.organization-admin-overview-delay-load-data-provider")
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Body = @{
        'contributionIds' = $ContributionIds
    } | ConvertTo-Json -Depth 100

    $Uri = "https://dev.azure.com/$Organization/_apis/Contribution/HierarchyQuery?api-version=7.2-preview"

    $Response = InvokeADOPSRestMethod -Uri $Uri -Method Post -Body $Body

    if ($Response.dataProviderExceptions) {
        $Response.dataProviderExceptions
    }
    else {
        $Response.dataProviders
    }

}