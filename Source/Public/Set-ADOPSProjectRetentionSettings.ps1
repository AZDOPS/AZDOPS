function Set-ADOPSProjectRetentionSettings {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        $Values
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/build/retention?api-version=7.1-preview.1"

    $Body = PatchADOPSRetentionSettings -Values $Values | ConvertTo-Json
    Write-Debug $Body
    $Response = InvokeADOPSRestMethod -Uri $Uri -Method Patch -Body $Body
    Write-Debug $Response

    $Settings = GetADOPSRetentionSettings -Response $Response
    
    Write-Output $Settings
}