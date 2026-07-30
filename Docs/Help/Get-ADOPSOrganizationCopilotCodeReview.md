---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSOrganizationCopilotCodeReview

## SYNOPSIS
Get the Azure DevOps organization wide GitHub Copilot code review settings

## SYNTAX

```
Get-ADOPSOrganizationCopilotCodeReview [[-Organization] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Get the Azure DevOps organization wide GitHub Copilot code review settings, found under Organization settings > Repositories.

Returns an object with an isEnabled property, indicating whether repositories in the organization are allowed to use Copilot code review, and an agentPoolId property identifying the agent pool the reviewer runs on.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSOrganizationCopilotCodeReview
```

Get the Copilot code review settings for the organization in the current context.

### Example 2
```powershell
PS C:\> (Get-ADOPSOrganizationCopilotCodeReview -Organization 'myorg').isEnabled
```

Return only the enablement state for the named organization.

## PARAMETERS

### -Organization
The organization to get the Copilot code review settings from.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
