---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSUser

## SYNOPSIS

Fetch one or more users

## SYNTAX

### All (Default)

```
Get-ADOPSUser [-Organization <String>] [<CommonParameters>]
```

### Name

```
Get-ADOPSUser [-Name] <String> [-Organization <String>] [<CommonParameters>]
```

### Descriptor

```
Get-ADOPSUser [-Descriptor] <String> [-Organization <String>] [<CommonParameters>]
```

## DESCRIPTION

Fetch user(s) by name or descriptor

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ADOPSUser
```

Fetch all users.

### Example 2

```powershell
PS C:\> Get-ADOPSUser -Name 'john doe'
```

Search for anyone that has `john doe` in it's name, display name or email.

### Example 3

```powershell
PS C:\> Get-ADOPSUser -Descriptor 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
```

Search for a single user that has the corresponding descriptor.

## PARAMETERS

### -Descriptor

A unique _descriptor_ ID for the user.

```yaml
Type: String
Parameter Sets: Descriptor
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

The query that will match name, display name, email fields.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization

The organization to get users from.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

https://docs.microsoft.com/en-us/rest/api/azure/devops/memberentitlementmanagement/user-entitlements/search-user-entitlements?view=azure-devops-rest-6.0

https://docs.microsoft.com/en-us/rest/api/azure/devops/graph/users/get?view=azure-devops-rest-6.0

https://docs.microsoft.com/en-us/rest/api/azure/devops/graph/users/list?view=azure-devops-rest-6.0
