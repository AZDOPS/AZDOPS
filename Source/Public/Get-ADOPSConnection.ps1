function Get-ADOPSConnection {
    [SkipTest('HasOrganizationParameter')]
    [CmdletBinding()]
    Param()

    
    if ($Script:ADOPSCredentials) {
        $Res = $Script:ADOPSCredentials
    }
    else {
        try {
            $staticStoragePath = GetADOPSConfigPath
            if (Test-Path -Path $staticStoragePath) {
                $Res = Get-Content $staticStoragePath | ConvertTo-SecureString | ConvertFrom-SecureString -AsPlainText | ConvertFrom-Json
            }
        }
        catch {
            Write-Warning 'Found ADOPS settings file, but failed to read it. Create a new setting and use Persist to recreate it.'
        }
    }

    if ($Res) {
        Write-Verbose "ADOPS connection found."
        Return $Res
    }
    else {
        Write-Verbose "No ADOPS connection found. Use Set-ADOPSConnection to create it."
    }
} 