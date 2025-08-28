#Requires -Modules @{ ModuleName="AzAuth"; ModuleVersion="2.2.2" }

param(
	[parameter(Position = 0, Mandatory = $false)][boolean]$AllowInsecureApis = $false
)

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

# import classes
foreach ($file in (Get-ChildItem "$PSScriptRoot\Classes\*.ps1")) {
	try {
		Write-Verbose "Importing $($file.FullName)"
		. $file.FullName
	}
	catch {
		Write-Error "Failed to import '$($file.FullName)'. $_"
	}
}

# import private functions
foreach ($file in (Get-ChildItem "$PSScriptRoot\Private\*.ps1")) {
	try {
		Write-Verbose "Importing $($file.FullName)"
		. $file.FullName
	}
	catch {
		Write-Error "Failed to import '$($file.FullName)'. $_"
	}
}

# import public functions
foreach ($file in (Get-ChildItem "$PSScriptRoot\Public\*.ps1")) {
	try {
		Write-Verbose "Importing $($file.FullName)"
		. $file.FullName
	}
	catch {
		Write-Error "Failed to import '$($file.FullName)'. $_"
	}
}
