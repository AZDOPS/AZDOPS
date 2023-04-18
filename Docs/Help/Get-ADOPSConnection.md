---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSConnection

## SYNOPSIS
Gets all established connections to Azure DevOps.

## SYNTAX

```
Get-ADOPSConnection
```

## DESCRIPTION
This commands lists all established connections to Azure DevOps.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSConnection

Name                           Value
----                           -----
Organization                   Org1
OauthToken                     OAuthToken
UserContext                    @{UserData}
Default                        False
Organization                   Org2
OauthToken                     OAuthToken
UserContext                    @{UserData}
Default                        False
```

This command lists all organizations your OAuth token is valid with.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
