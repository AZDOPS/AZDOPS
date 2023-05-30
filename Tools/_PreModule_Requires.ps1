#Requires -Modules @{ ModuleName="AzAuth"; ModuleVersion="2.2.2" }

$script:AzTokenCache = 'adops.cache'

$script:loginMethod = 'Default'