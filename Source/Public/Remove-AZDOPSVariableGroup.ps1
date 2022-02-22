function Remove-AZDOPSVariableGroup {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [string]$ProjectName,

        [Parameter(Mandatory)]
        [string]$VariableGroupName
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetAZDOPSHeader -Organization $Organization
    }
    else {
        $Org = GetAZDOPSHeader
        $Organization = $Org['Organization']
    }

    $Uri = "https://dev.azure.com/$Organization/$ProjectName/_apis/distributedtask/variablegroups?api-version=7.1-preview.2"
    $VariableGroups = (InvokeAZDOPSRestMethod -Uri $Uri -Method 'Get' -Organization $Organization).value

    $GroupToRemove = $VariableGroups | Where-Object name -eq $VariableGroupName
    if ($null -eq $GroupToRemove) {
        throw "Could not find group $VariableGroupName! Groups found: $($VariableGroups.name -join ', ')."
    }
    
    $ProjectId = (Get-AZDOPSProject -Organization $Organization -ProjectName $ProjectName).id

    $URI = "https://dev.azure.com/$Organization/_apis/distributedtask/variablegroups/$($GroupToRemove.id)?projectIds=$ProjectId&api-version=7.1-preview.2"
    $null = InvokeAZDOPSRestMethod -Uri $Uri -Method 'Delete' -Organization $Organization
}