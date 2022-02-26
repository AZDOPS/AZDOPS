function New-ADOPSVariableGroup {
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = 'VariableSingle')]
        [Parameter(ParameterSetName = 'VariableHashtable')]
        [string]$Organization,

        [Parameter(Mandatory, ParameterSetName = 'VariableSingle')]
        
        [Parameter(Mandatory, ParameterSetName = 'VariableHashtable')]
        [string]$Project,

        [Parameter(Mandatory, ParameterSetName = 'VariableSingle')]
        [Parameter(Mandatory, ParameterSetName = 'VariableHashtable')]
        [string]$VariableGroupName,

        [Parameter(Mandatory, ParameterSetName = 'VariableSingle')]
        [string]$VariableName,

        [Parameter(Mandatory, ParameterSetName = 'VariableSingle')]
        [string]$VariableValue,

        [Parameter(ParameterSetName = 'VariableSingle')]
        [switch]$IsSecret,

        [Parameter()]
        [string]$Description,

        [Parameter(Mandatory, ParameterSetName = 'VariableHashtable')]
        [hashtable]$VariableHashtable
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    }
    else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    $ProjectInfo = Get-ADOPSProject -Organization $Organization -Project $Project

    $URI = "https://dev.azure.com/${Organization}/_apis/distributedtask/variablegroups?api-version=7.1-preview.2"
    $method = 'POST'

    if ($VariableName) {
        $Body = @{
            Name                           = $VariableGroupName
            Description                    = $Description
            Type                           = 'Vsts'
            variableGroupProjectReferences = @(@{
                    Name             = $VariableGroupName
                    Description      = $Description
                    projectReference = @{
                        Id = $ProjectInfo.Id
                    }
                })
            variables                      = @{
                $VariableName = @{
                    isSecret = $IsSecret.IsPresent
                    value    = $VariableValue
                }
            }
        } | ConvertTo-Json -Depth 10
    }
    else {
        $Body = @{
            Name                           = $VariableGroupName
            Description                    = $Description
            Type                           = 'Vsts'
            variableGroupProjectReferences = @(@{
                    Name             = $VariableGroupName
                    Description      = $Description
                    projectReference = @{
                        Id = $($ProjectInfo.Id)
                    }
                })
            variables                      = $VariableHashtable
        } | ConvertTo-Json -Depth 10
    }

    InvokeADOPSRestMethod -Uri $Uri -Method $Method -Body $Body -Organization $Organization
}