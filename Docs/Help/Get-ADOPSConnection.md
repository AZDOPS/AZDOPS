---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSConnection

## SYNOPSIS
This command gets the active ADOPS connection.

## SYNTAX

```
Get-ADOPSConnection
```

## DESCRIPTION
This command gets the active ADOPS connection. If no connection is made it will return $null.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSConnection

Name                           Value
----                           -----
TenantId                       97547e13-918b-47eb-a923-6e58efef2e6a
Identity                       my.mail@address
Organization                   MYConnectedOrg
```

This command will output any current ADOPS connection

## PARAMETERS

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
