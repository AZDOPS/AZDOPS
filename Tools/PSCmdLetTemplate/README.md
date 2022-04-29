# How to use Plaster PS CmdLet Template

This will create a {CmdletName}.ps1 file some basic function code, in the "Public" or "Private" folder depending on your selection.

It will also create a {CmdletName}.tests.ps1 with some basic tests in the "Tests" folder.

## Prerequisite

In order to use the Plaster template you need to install Plaster module.

```powershell
Install-Module -Name Plaster
```

## EXAMPLES

Note: you need to point 'DestinationPath' to the Root folder on the Repository.
### EXAMPLE 1

```powershell
Invoke-Plaster -NoLogo -TemplatePath .\Tools\PSCmdLetTemplate -DestinationPath .
```

This will invoke Plaster and prompt you for 'CmdletName' and 'Type'.


### EXAMPLE 2

```powershell
Invoke-Plaster -NoLogo -TemplatePath .\Tools\PSCmdLetTemplate -DestinationPath . -CmdletName Get-FooBar -Type Private
``` 

This will invoke Plaster using the parameters 'CmdletName' and 'Type'.
