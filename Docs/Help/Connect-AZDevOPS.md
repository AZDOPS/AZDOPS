---
external help file: AZDevOPS-help.xml
Module Name: AZDevOPS
online version:
schema: 2.0.0
---

# Connect-AZDevOPS

## SYNOPSIS

Establish a connection to Azure DevOps using a PAT.

## SYNTAX

```powershell
Connect-AZDevOPS [-Username] <String> [-PersonalAccessToken] <String> [-Organization] <String> [-Default]
 [<CommonParameters>]
```

## DESCRIPTION

Establish a connection to Azure DevOps using a PAT.

Can replace an existing connection by specifying the same organization again.

## EXAMPLES

### Example 1

```powershell
Connect-AZDevOps -Username 'john.doe@azdevops.com' -PersonalAccessToken '<myPersonalAccessToken>' -Organization 'AZDevOPS'
```

Connect to Azure DevOps organization using a personal access token.

### Example 2

```powershell
Connect-AZDevOps -Username 'john.doe@azdevops.com' -PersonalAccessToken '<myPersonalAccessToken>' -Organization 'AZDevOPS' -Default
```

Connect to Azure DevOps organization using a personal access token and setting it as default organization.

## PARAMETERS

### -Default

Specifies if the connection should be the default connection or not.

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

### -Organization

Name of the Azure DevOps organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PersonalAccessToken

Specifies the Personal Access Token to use for the connection.

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

### -Username

Username to use for the connection in the format of UPN.

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
