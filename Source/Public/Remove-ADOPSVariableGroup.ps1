function Remove-ADOPSVariableGroup {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter(Mandatory)]
        [string]$VariableGroupName
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    }
    else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/distributedtask/variablegroups?api-version=7.1-preview.2"
    $VariableGroups = (InvokeADOPSRestMethod -Uri $Uri -Method 'Get' -Organization $Organization).value

    $GroupToRemove = $VariableGroups | Where-Object name -eq $VariableGroupName
    if ($null -eq $GroupToRemove) {
        throw "Could not find group $VariableGroupName! Groups found: $($VariableGroups.name -join ', ')."
    }
    
    $ProjectId = (Get-ADOPSProject -Organization $Organization -Project $Project).id

    $URI = "https://dev.azure.com/$Organization/_apis/distributedtask/variablegroups/$($GroupToRemove.id)?projectIds=$ProjectId&api-version=7.1-preview.2"
    $null = InvokeADOPSRestMethod -Uri $Uri -Method 'Delete' -Organization $Organization
}