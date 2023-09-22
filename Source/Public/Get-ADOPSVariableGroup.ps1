function Get-ADOPSVariableGroup {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Name')]
        [Parameter(ParameterSetName = 'Id')]
        [string]$Organization,
        
        [Parameter(Mandatory, ParameterSetName = 'All')]
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [string]$Project,
        
        [Parameter(ParameterSetName = 'Name')]
        [string]$Name,
        
        [Parameter(ParameterSetName = 'Id')]
        [int]$Id
    )
    
    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Method = 'Get'

    if ($PSCmdlet.ParameterSetName -eq 'Name') {
        $Uri = "https://dev.azure.com/$Organization/$Project/_apis/distributedtask/variablegroups?groupName=$Name&api-version=7.2-preview.2"
    }
    else {
        $Uri = "https://dev.azure.com/$Organization/$Project/_apis/distributedtask/variablegroups?api-version=7.2-preview.2"
    }

    $InvokeSplat = @{
        Uri = $Uri
        Method = $Method
    }

    $result = (InvokeADOPSRestMethod @InvokeSplat).value

    if ($PSCmdlet.ParameterSetName -eq 'Id') {
        $result = $result.Where({$_.Id -eq $Id})
    }

    Write-Output $result
}