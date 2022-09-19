---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSUsageData

## SYNOPSIS
Gets the usage data of your organization.

## SYNTAX

```
Get-ADOPSUsageData [[-ProjectVisibility] <String>] [-SelfHosted] [<CommonParameters>]
```

## DESCRIPTION
This command gets usage data for you organization, such as

- Currently running requests
- Limits to your resource usage
- Parallel sessions
- Used minutes and hosts

Note: This API is not public, and user data is dependent on current status, and is due to change with no notice.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSUsageData
```

This command will return usage statistics and data for your public projects (default), and Microsoft hosted agents (default).

### Example 2
```powershell
PS C:\> Get-ADOPSUsageData -ProjectVisibility Private -SelfHosted
```

This command will return usage statistics and data for your private projects, and self hosted agents.

### Example 3
```powershell
PS C:\> Get-ADOPSUsageData -ProjectVisibility Public
```

This command will return usage statistics and data for your public projects (default), and Microsoft hosted agents (default).

## PARAMETERS

### -ProjectVisibility
List usage data for private or public projects

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Private, Public

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SelfHosted
If set, returns usage data for self hosted agents.
If not set, returns usage data for Microsoft hosted agents.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
