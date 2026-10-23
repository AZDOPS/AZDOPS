function Get-ADOPSOrganizationCopilotCodeReview {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Body = '{
        "contributionIds": [
            "ms.vss-code-web.settings-options"
        ]
    }'

    $Uri = "https://dev.azure.com/$Organization/_apis/Contribution/HierarchyQuery?api-version=7.1-preview"

    (InvokeADOPSRestMethod -Uri $Uri -Method Post -Body $Body).dataProviders.'ms.vss-code-web.copilot-code-review-org-settings-data-provider'

}
