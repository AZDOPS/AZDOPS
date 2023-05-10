function NewAzToken {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param ()

    switch ($script:LoginMethod) {
        'Default' {
            try {
                Get-AzToken -TokenCache $script:AzTokenCache
            }
            catch {
                if ($_.Exception.GetType().FullName -eq 'Azure.Identity.CredentialUnavailableException') {
                    throw (New-Object -TypeName 'System.InvalidOperationException' -ArgumentList "Could not find existing token, please run the command Connect-ADOPS!",$_)
                }
                else {
                    throw $_
                }
            }
        }
        'ManagedIdentity' {
            Get-AzToken -ManagedIdentity
        }
        'Token' {
            return $Script:ScriptToken
        }
        Default {
            throw 'No login method was set, module file may have been corrupted!'
        }
    }
}
