---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Invoke-ADOPSRestMethod

## SYNOPSIS
Invoke a ADOPS rest API call.

## SYNTAX

```
Invoke-ADOPSRestMethod [-Uri] <String> [[-Method] <WebRequestMethod>] [[-Body] <String>] [<CommonParameters>]
```

## DESCRIPTION
This command invokes a API call to Azure DevOps using the default logged in account (Get-ADOPSConnection | Where-Object {$_.Values.Default -EQ $true}). You will need to give the full Uri to call, for example
http://dev.azure.com/myOrganization/_api/GetStuff

## EXAMPLES

### Example 1
```powershell
PS C:\> InvokeADOPSRestMethod -Uri "https://dev.azure.com/$Organization/_apis/distributedtask/tasks"

```

This command will return whatever this API endpoint returns. It will perform the API call using the logged in "Default" credentials

### Example 2
```powershell
PS C:\> InvokeADOPSRestMethod -Uri "https://dev.azure.com/$Organization/_apis/distributedtask/tasks" -Method Post -Body $BodyObject

```

This command will perform a Post call to the API endpoint. It will perform the API call using the logged in "Default" credentials. It will include the body object in the call. It will _not_ format or validate any of the input values.

## PARAMETERS

### -Body
Body to include in the API call

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
API method to use

```yaml
Type: WebRequestMethod
Parameter Sets: (All)
Aliases:
Accepted values: Default, Get, Head, Post, Put, Delete, Trace, Options, Merge, Patch

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Uri
Full Uri to call, including "https://dev.azure.com/organization"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
