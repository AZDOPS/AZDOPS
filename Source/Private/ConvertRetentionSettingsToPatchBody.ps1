<#
.SYNOPSIS
Converts Retention Settings Dictionary<string, int> into RetentionSetting objects

.DESCRIPTION
Converts Retention Settings Dictionary<string, int> into RetentionSetting objects.

.PARAMETER Values
Keyed dictionary of integers

Example:
@{
    artifactsRetention = 51
    runRetention = 51,
    ...
}

.OUTPUTS
@{
    artifactsRetention = @{
        min = 0,
        max = 0,
        value = 51
    },
    runRetention = @{
        min = 0,
        max = 0,
        value = 51
    },
    ...
}
#>
function ConvertRetentionSettingsToPatchBody {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param (
        [Parameter(Mandatory)]
        $Values
    )

    $Settings = @{}
    if ($Values -is [pscustomobject]) {
        foreach ($ValueProperty in $Values.psobject.Properties) {
            $Settings[$ValueProperty.Name] = @{
                value = $ValueProperty.Value
                min   = $null
                max   = $null
            }
        }
    }
    else {
        foreach ($Value in $Values.GetEnumerator()) {
            $Settings[$Value.key] = @{
                value = $Value.value
                min   = $null
                max   = $null
            }
        }
    }

    [pscustomobject]$Settings
}