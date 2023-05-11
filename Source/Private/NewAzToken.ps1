function NewAzToken {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param ()

    $TokenSplat = @{
        Resource = '499b84ac-1321-427f-aa17-267ca6975798'
    }
    switch ($script:LoginMethod) {
        'Default' {
            try {
                $UserContext = GetADOPSConfigFile

                $TokenSplat['Username'] = $Usercontext['Default']['Identity']
                $TokenSplat['TenantId'] = $Usercontext['Default']['TenantId']
                Get-AzToken @TokenSplat -TokenCache $script:AzTokenCache
            }
            catch {
                # Make sure we present the inner exception to users but with a nicer error message
                if ($_.Exception.GetType().FullName -eq 'Azure.Identity.CredentialUnavailableException') {
                    $Exception = New-Object System.InvalidOperationException "Could not find existing token, please run the command Connect-ADOPS!", $_.Exception
                    $ErrorRecord = New-Object Management.Automation.ErrorRecord $Exception, 'ADOPSGetTokenError', ([System.Management.Automation.ErrorCategory]::InvalidOperation), $null
                    throw $ErrorRecord
                }
                else {
                    throw $_
                }
            }
        }
        'ManagedIdentity' {
            Get-AzToken @TokenSplat -ManagedIdentity
        }
        'Token' {
            return $Script:ScriptToken
        }
        Default {
            throw 'No login method was set, module file may have been corrupted!'
        }
    }
}
