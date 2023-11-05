function Set-ADOPSPipelineSettings {
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = 'Value')]
        [Parameter(ParameterSetName = 'Values')]
        [string]$Organization,

        [Parameter(ParameterSetName = 'Value')]
        [Parameter(ParameterSetName = 'Values')]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter(Mandatory, ParameterSetName = 'Value')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Value')]
        [boolean]$Value,

        [Parameter(Mandatory, ParameterSetName = 'Values')]
        $Values
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/build/generalsettings?api-version=7.1-preview.1"
    $Body = @{}

    if ($PSCmdlet.ParameterSetName -eq "Value") {
        $Body.$Name = $Value
    }
    elseif ($PSCmdlet.ParameterSetName -eq "Values") {
        $Body = $Values
    }

    $Body =  $Body | ConvertTo-Json -Compress
    $Settings = InvokeADOPSRestMethod -Uri $Uri -Method 'PATCH' -Body $Body -Debug

    Write-Output $Settings
}