---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSMembership

## SYNOPSIS
Gets membership of or in target descriptor

## SYNTAX

```
Get-ADOPSMembership [[-Organization] <String>] [-Descriptor] <String> [[-Direction] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets membership of or in target descriptor

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSMembership -Descriptor 'vssgp.Uy0xLTktMTU1MTM3NBI0NS0zNjE3OTkwMTAxLTE2NDMyOTI3NDLtMjI3NTA1MDMxMo0zNDgyOTQ1MDkzLTAtMC0wLTAtMQ'
```

Gets membership of target descriptor

### Example 2
```powershell
PS C:\> Get-ADOPSMembership -Descriptor 'vssgp.Uy0xLTktMTU1MTM3NBI0NS0zNjE3OTkwMTAxLTE2NDMyOTI3NDLtMjI3NTA1MDMxMo0zNDgyOTQ1MDkzLTAtMC0wLTAtMQ' -Direction 'down'
```

Gets membership in target descriptor
## PARAMETERS

### -Descriptor
Descriptor

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

### -Organization
Azure DevOps Organization

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

### -Direction
The default value for direction is 'up' meaning return all memberships where the subject is a member (e.g. all groups the subject is a member of). Alternatively, passing the direction as 'down' will return all memberships where the subject is a container (e.g. all members of the subject group).

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: up, down

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