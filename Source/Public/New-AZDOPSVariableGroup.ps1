function New-AZDOPSVariableGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
            ParameterSetName = "VariableSingle")]

        [Parameter(Mandatory,
            ParameterSetName = "VariableHashtable")]
        [string]$Organization,

        [Parameter(Mandatory,
            ParameterSetName = "VariableSingle")]
        
        [Parameter(Mandatory,
            ParameterSetName = "VariableHashtable")]
        [string]$ProjectName,

        [Parameter(Mandatory,
            ParameterSetName = "VariableSingle")]
        [Parameter(Mandatory,
            ParameterSetName = "VariableHashtable")]
        [string]$VariableGroupName,

        [Parameter(ParameterSetName = "VariableSingle")]
        [string]$VariableName,

        [Parameter(ParameterSetName = "VariableSingle")]
        [string]$VariableValue,

        [Parameter(ParameterSetName = "VariableSingle")]
        [switch]$IsSecret,

        [Parameter()]
        [string]$Description,

        [Parameter(ParameterSetName = "VariableHashtable")]
        [hashtable]$VariableHashtable
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

    if ($VariableName) {
        $Body = @{
            Name                           = "$VariableGroupName"
            Description                    = "$Description"
            Type                           = "Vsts"
            variableGroupProjectReferences = @(@{
                    Name             = "$VariableGroupName"
                    Description      = "$Description"
                    projectReference = @{
                        Id = "$($ProjectInfo.Id)"
                    }
                })
            variables                      = @{
                "$VariableName" = @{
                    isSecret = $IsSecret.IsPresent
                    value    = "$VariableValue"
                }
            }
        } | ConvertTo-Json -Depth 10
    }
    else {
        $Body = @{
            Name                           = "$VariableGroupName"
            Description                    = "$Description"
            Type                           = "Vsts"
            variableGroupProjectReferences = @(@{
                    Name             = "$VariableGroupName"
                    Description      = "$Description"
                    projectReference = @{
                        Id = "$($ProjectInfo.Id)"
                    }
                })
            variables                      = $VariableHashtable
        } | ConvertTo-Json -Depth 10
    }

    InvokeAZDOPSRestMethod -Uri $Uri -Method $Method -Body $Body -Organization $Organization
}