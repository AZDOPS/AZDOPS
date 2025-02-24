function New-ADOPSGroupEntitlement {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$GroupOriginId,

        [Parameter()]
        [ValidateSet('account')]
        [string]$LicensingSource = 'account',

        [Parameter(Mandatory)]
        [ValidateSet('Express', 'Advanced', 'Stakeholder', 'Professional', 'EarlyAdopter')]
        [string]$AccountLicenseType,

        [Parameter(Mandatory)]
        [ValidateSet('projectReader', 'projectContributor', 'projectAdministrator', 'projectStakeholder')]
        [string]$ProjectGroupType,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization,

        [Parameter()]
        [switch]$Wait
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    # Group entitlements endpoint
    $URI = "https://vsaex.dev.azure.com/$Organization/_apis/GroupEntitlements?api-version=7.1"

    # Initialize the request body
    $Body = @{
        extensionRules = @(
            @{
                id = 'ms.feed'
            }
        )
        group = @{
            origin = 'aad'
            originId = $GroupOriginId
            subjectKind = 'group'
        }
        licenseRule = @{
            licensingSource = 'account'
            accountLicenseType = $AccountLicenseType
        }
        projectEntitlements = @(
            @{
                group = @{
                    groupType = $ProjectGroupType
                }
                projectRef = @{
                    id = $ProjectId
                }
            }
        )
    }

    $InvokeSplat = @{
        Method = 'Post'
        Uri = $URI
        Body = ($Body | ConvertTo-Json -Compress -Depth 10)
    }

    $Out = InvokeADOPSRestMethod @InvokeSplat

    if ($PSBoundParameters.ContainsKey('Wait')) {
        while ($Out.operationResult.status -eq 'inProgress') {
            Start-Sleep -Seconds 1
            $Out = Invoke-ADOPSRestMethod -Uri $Out.operationResult.statusUrl -Method Get
        }
    }

    $Out
}