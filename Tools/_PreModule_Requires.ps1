#Requires -Modules @{ ModuleName="AzAuth"; ModuleVersion="2.2.1" }

$script:AzTokenCache = 'adops.cache'

$script:loginMethod = 'Default'