---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Set-ADOPSProject

## SYNOPSIS
Updates Azure DevOps project information.

## SYNTAX

### ProjectName (Default)
```
Set-ADOPSProject [-Organization <String>] -ProjectName <String> [-Description <String>] [-Visibility <String>]
 [-Wait] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ProjectId
```
Set-ADOPSProject [-Organization <String>] -ProjectId <String> [-Description <String>] [-Visibility <String>]
 [-Wait] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This command will update information of an Azure DevOps project.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-ADOPSProject -ProjectName 'myProject' -Description 'New description' -Visibility Private -Wait
```

This command will set the properties 'Description' and 'Visibility' of the 'myProject' project.
It will wait until the status of the update is completed, failed, or cancelled before returning the result.

### Example 2
```powershell
PS C:\> Set-ADOPSProject -ProjectName 'myProject' -Description ([string]::Empty)
```

This command will clear the 'myProject' project description.
It will return the status even if the update is not yet completed.

## PARAMETERS

### -Description
Set the Project description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
The organization to update the project in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectId
Project ID of the project to update. Only needed if no ProjectName is given.

```yaml
Type: String
Parameter Sets: ProjectId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectName
Project name of the project to update. Only needed if no ProjectId is given.

```yaml
Type: String
Parameter Sets: ProjectName
Aliases: Project, Name

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Visibility
Sets project visibility.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Private, Public

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait
Wait for the status update to be set to 'Complete', 'Failed', or 'Cancelled'

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
