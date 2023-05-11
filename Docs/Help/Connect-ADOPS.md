---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Connect-ADOPS

## SYNOPSIS

Establish a connection to Azure DevOps using a PAT.

## SYNTAX

### Interactive (Default)
```
Connect-ADOPS -Organization <String> [-TenantId <String>] [-Interactive] [<CommonParameters>]
```

### OAuthToken
```
Connect-ADOPS -Organization <String> -OAuthToken <String> [<CommonParameters>]
```

### Token
```
Connect-ADOPS -Organization <String> [-TenantId <String>] [<CommonParameters>]
```

### ManagedIdentity
```
Connect-ADOPS -Organization <String> [-TenantId <String>] [-ManagedIdentity] [<CommonParameters>]
```

## DESCRIPTION

Establish a connection to Azure DevOps using a PAT.

Can replace an existing connection by specifying the same organization again.

## EXAMPLES

### Example 1

```powershell
Connect-ADOPS -Username 'john.doe@ADOPS.com' -PersonalAccessToken '<myPersonalAccessToken>' -Organization 'ADOPS'
```

Connect to Azure DevOps organization using a personal access token.

### Example 2

```powershell
$Creds = Get-Credential -Username 'john.doe@ADOPS.com' 
# Insert PAT as password

Connect-ADOPS -Credential $Creds -Organization 'ADOPS'
```

Connect to Azure DevOps organization using a credential object.

### Example 3

```powershell
Connect-ADOPS -Username 'john.doe@ADOPS.com' -PersonalAccessToken '<myPersonalAccessToken>' -Organization 'ADOPS' -Default
```

Connect to an Azure DevOps organization and set it as default.

## PARAMETERS

### -Organization

Name of the Azure DevOps organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Interactive

Connect to an Azure DevOps organization using an interactive browser login.

```yaml
Type: SwitchParameter
Parameter Sets: Interactive
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagedIdentity

Connect to an Azure DevOps organization using a managed identity.

```yaml
Type: SwitchParameter
Parameter Sets: ManagedIdentity
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OAuthToken

Connect to an Azure DevOps organization using an existing access token.

```yaml
Type: String
Parameter Sets: OAuthToken
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantId

Specify a tenant to connect to, by id.

```yaml
Type: String
Parameter Sets: Interactive, Token, ManagedIdentity
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
