function Get-ADOPSProject {
    [CmdletBinding(DefaultParameterSetName='All')]
    param (
        [Parameter(ParameterSetName='All')]
        [Parameter(ParameterSetName='ByName')]
        [Parameter(ParameterSetName='ById')]
        [string]$Organization,

        [Parameter(ParameterSetName='ByName')]
        [Alias('Project')]
        [string]$Name,

        [Parameter(ParameterSetName='ById')]
        [string]$Id

    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://dev.azure.com/$Organization/_apis/projects?api-version=7.1-preview.4"

    $Method = 'GET'
    $ProjectInfo = (InvokeADOPSRestMethod -Uri $Uri -Method $Method).value

    if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        $ProjectInfo = $ProjectInfo | Where-Object -Property Name -eq $Name
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ById') {
        $ProjectInfo = $ProjectInfo | Where-Object -Property Id -eq $Id
    }

    Write-Output $ProjectInfo
}