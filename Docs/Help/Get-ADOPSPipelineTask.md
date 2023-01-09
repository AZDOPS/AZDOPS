---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSPipelineTask

## SYNOPSIS
Returns one or more pipeline tasks.

## SYNTAX

```
Get-ADOPSPipelineTask [[-Name] <String>] [[-Organization] <String>] [[-Version] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
This command will return one or more pipeline tasks available in your organization.
If no parameters is given it will return all tasks installed in your Azure DevOps environment.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSPipelineTask
```

This command will return all pipeline tasks and all versions available in your organization.

### Example 2
```powershell
PS C:\> Get-ADOPSPipelineTask -Name 'PowerShell'
```

This command will return pipeline tasks with the exact name "PowerShell", All versions available in your organization.

### Example 3
```powershell
PS C:\> Get-ADOPSPipelineTask -Version 1
```

This command will return all pipeline tasks with major version 1 available in your organization.

### Example 4
```powershell
PS C:\> Get-ADOPSPipelineTask -Name 'PowerShell' -Version 2
```

This command will return the PowerShell pipeline task version 2.

## PARAMETERS

### -Name
Name of the task to search for. Exact matches, no wildcards.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
The organization to search for tasks in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Major version of task(s) to return

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
