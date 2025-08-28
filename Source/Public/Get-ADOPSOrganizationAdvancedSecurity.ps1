function Get-ADOPSOrganizationAdvancedSecurity {
    [CmdletBinding(DefaultParameterSetName = 'Org')]
    param (
        [Parameter(ParameterSetName = 'Org')]
        [Parameter(ParameterSetName = 'Project')]
        [Parameter(ParameterSetName = 'Repository')]
        [string]$Organization,

        [Parameter(Mandatory, ParameterSetName = 'Project')]
        [Parameter(Mandatory, ParameterSetName = 'Repository')]
        [string]
        $Project,

        [Parameter(Mandatory, ParameterSetName = 'Repository')]
        [string]
        $Repository
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    switch ($PSCmdlet.ParameterSetName) {
        'Org' {
            $Uri = "https://advsec.dev.azure.com/$Organization/_apis/Management/enablement?api-version=7.2-preview.1"
        }
        'Project' {
            $Uri = "https://advsec.dev.azure.com/$Organization/$Project/_apis/Management/enablement?api-version=7.2-preview.1"
        }
        'Repository' {
            $Uri = "https://advsec.dev.azure.com/$Organization/$Project/_apis/management/repositories/$Repository/enablement?api-version=7.2-preview.1"
        }
    }

    $Result = InvokeADOPSRestMethod -Uri $Uri -Method 'Get'

    Write-Output $Result
}