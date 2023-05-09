#Requires -Modules @{ ModuleName="AzAuth"; ModuleVersion="2.1.0" }

$script:AzTokenCache = 'adops.cache'

$script:loginMethod = 'Default'