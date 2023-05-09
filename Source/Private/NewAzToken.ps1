function NewAzToken {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param ()

    switch ($script:LoginMethod) {
        'Default' {
            Get-AzToken -TokenCache $script:AzTokenCache
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
