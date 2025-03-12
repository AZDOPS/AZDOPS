---
external help file: ADOPS-help.xml
Module Name: ADOPs
online version:
schema: 2.0.0
---

# Get-ADOPSAgentQueue

## SYNOPSIS
Gets one or more agent queues (pools) connected to a project

## SYNTAX

```
Get-ADOPSAgentQueue [[-Organization] <String>] [-Project] <String> [[-QueueName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This command will get all or one named agent queue.
Agent queues is what the Azure DevOps GUI refers to ass pools, connected to a project,
as in the `Project Settings` -> `Pipelines` -> `Agent Pools` page.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSAgentQueue -Project 'MyProject'
```

This command lists all agent queues in the `MyProject` project

### Example 2
```powershell
PS C:\> Get-ADOPSAgentQueue -Project 'MyProject' -QueueName 'MyQueue'
```

This command gets the `MyQueue` agent queue in the `MyProject` project.
If no queue named `MyQueue` exists it will return nothing.

## PARAMETERS

### -Organization

The organization to get queues from.

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

### -Project

The project to get queues from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QueueName
Specifies one specific queue to get.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
