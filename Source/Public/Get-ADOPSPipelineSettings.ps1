function Get-ADOPSPipelineSettings {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/build/generalsettings?api-version=7.1-preview.1"
    $Settings = InvokeADOPSRestMethod -Uri $Uri -Method Get

    if ($PSBoundParameters.ContainsKey("Name")) {
        $Setting = $Settings.$Name
        Write-Output $Setting
    }
    else {
        Write-Output $Settings
    }
}