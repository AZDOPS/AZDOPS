function Set-ADOPSConnection {
    [SkipTest('HasOrganizationParameter')]
    [CmdletBinding()]
    Param(
        [string]$DefaultOrganization,

        [string]$AzureADTennantId,

        [switch]$Persist
    )

    $staticStoragePath = GetADOPSConfigPath

    if ($Script:ADOPSCredentials) {
        $ConnectionObj = $Script:ADOPSCredentials
    }
    elseif (Test-Path -Path $staticStoragePath) {
        try {
            $ConnectionObj = Get-Content $staticStoragePath | ConvertTo-SecureString | ConvertFrom-SecureString -AsPlainText | ConvertFrom-Json -AsHashtable
        }
        catch {
            Write-Warning 'Found ADOPS settings file, but failed to read it. Create a new setting and use Persist to recreate it.'
            $ConnectionObj = @{}
        }
    }
    else {
        $ConnectionObj = @{}
    }

    if ($PSBoundParameters.ContainsKey('DefaultOrganization')) {
        $ConnectionObj['Organization'] = $DefaultOrganization
    }

    if ($PSBoundParameters.ContainsKey('AzureADTennantId')) {
        $ConnectionObj['TenantId'] = $AzureADTennantId
    }

    if ($PSBoundParameters.ContainsKey('Persist')) {
        
        $SecureString = ConvertTo-SecureString -String ($ConnectionObj | ConvertTo-Json -Depth 10 -Compress) -AsPlainText -Force | ConvertFrom-SecureString
        $SecureString | Out-File $staticStoragePath -Force
    }

    $Script:ADOPSCredentials = $ConnectionObj
} 