function Set-ADOPSConnection {
    [SkipTest('HasOrganizationParameter')]
    [CmdletBinding()]
    Param(
        [string]$DefaultOrganization,
        
        [switch]$ForceRefresh
    )

    if ($ForceRefresh.IsPresent) {
        $Script:ADOPSCredentials = @()
        $Script:ADOPSCredentials = NewAzToken
    }

    if (-not [string]::IsNullOrEmpty($DefaultOrganization)) {
        if ($script:ADOPSCredentials.Count -eq 0) {
            try {
                $Script:ADOPSCredentials = NewAzToken
            }
            catch {
                throw 'No usable ADOPS credentials found. Use Connect-AzAccount or az login to connect.'
            }
        }

        
        try {
            ($Script:ADOPSCredentials | Where-Object {$_.organization -eq $DefaultOrganization}).default = $true
            $script:ADOPSCredentials | Where-Object {$_.default -and $_.organization -ne $DefaultOrganization} | ForEach-Object {$_.Default = $false}
        }
        catch {
            throw "No organization with name $DefaultOrganization found."
        }
    }
} 