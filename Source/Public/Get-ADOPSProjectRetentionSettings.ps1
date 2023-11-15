function Get-ADOPSProjectRetentionSettings {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/build/retention?api-version=7.2-preview.1"
    $Response = InvokeADOPSRestMethod -Uri $Uri -Method Get

    $Settings = GetADOPSRetentionSettings -Response $Response

    Write-Output $Settings
}