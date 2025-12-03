#Requires -Modules @{ ModuleName="AzAuth"; ModuleVersion="2.2.2" }

$script:AzTokenCache = 'adops.cache'

$script:loginMethod = 'Default'

if ($AllowInsecureApis -or $AdopsAllowInsecureApis) {
    [bool]$script:runInsecureApis = $true
}

$script:InsecureApisWarning = @'
This function uses unsupported APIs, that is not loaded per default.
To run this command anyway, use the -Force flag.
To load this command on module import, Either
- Run 'Import-Module .\Source\ADOPS.psm1 -ArgumentList $true'
- Set '$AdopsAllowInsecureApis = $true' in console before importing the module.
'@