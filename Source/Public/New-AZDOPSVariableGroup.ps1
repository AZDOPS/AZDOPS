function New-AZDOPSVariableGroup {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [string]$ProjectName,

        [Parameter(Mandatory)]
        [string]$VariableGroupName,

        [Parameter(Mandatory)]
        [string]$VariableName,

        [Parameter(Mandatory)]
        [string]$VariableValue,

        [Parameter()]
        [string]$Description
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetAZDOPSHeader -Organization $Organization
    }
    else {
        $Org = GetAZDOPSHeader
        $Organization = $Org['Organization']
    }

    $ProjectInfo = Get-AZDOPSProject -Organization $Organization -ProjectName $ProjectName

    $URI = "https://dev.azure.com/${Organization}/_apis/distributedtask/variablegroups?api-version=7.1-preview.2"
    $method = 'POST'

    $Body = @{
        Name                           = "$VariableGroupName"
        Description                    = "$Description"
        Type                           = "Vsts"
        variableGroupProjectReferences = @(@{
                Name             = "$VariableGroupName"
                Description      = "$Description"
                projectReference = @{
                    Id   = "$($ProjectInfo.Id)"
                }
            })
        variables                      = @{
            "$VariableName" = @{
                isSecret = $false
                value    = "$VariableValue"
            }
        }
    } | ConvertTo-Json -Depth 10

    InvokeAZDOPSRestMethod -Uri $Uri -Method $Method -Body $Body -Organization $Organization
}