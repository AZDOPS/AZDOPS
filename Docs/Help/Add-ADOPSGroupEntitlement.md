---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Add-ADOPSGroupEntitlement

## SYNOPSIS

Adds a group entitlement in Azure DevOps.

## SYNTAX

```
Add-ADOPSGroupEntitlement -GroupOriginId <String> -AccountLicenseType <String> -ProjectGroupType <String> -ProjectId <String>
 [-LicensingSource <String>] [-Organization <String>] [-Wait] [<CommonParameters>]
```

## DESCRIPTION

Adds a group entitlement in Azure DevOps, allowing you to manage licensing and access levels for Entra ID groups.

## EXAMPLES

### Example 1

```powershell
PS C:\> Add-ADOPSGroupEntitlement -GroupOriginId "01d0472d-9949-421e-81d8-fcb5668a394d" -AccountLicenseType "Express" -ProjectGroupType "projectContributor" -ProjectId "8130f18e-f65b-431d-a777-5d4a6f3468ba"
```

Adds a group entitlement for the specified Entra ID group with Express license and Contributor access to the specified project.

### Example 2

```powershell
PS C:\> Add-ADOPSGroupEntitlement -GroupOriginId "01d0472d-9949-421e-81d8-fcb5668a394d" -AccountLicenseType "Stakeholder" -ProjectGroupType "projectReader" -ProjectId "8130f18e-f65b-431d-a777-5d4a6f3468ba" -Organization "MyOrg" -Wait
```

Adds a group entitlement with Stakeholder license and Reader access to the specified project in the "MyOrg" organization, waiting for the operation to complete.

## PARAMETERS

### -GroupOriginId

The ID of the Entra ID group to add entitlements for.

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

### -AccountLicenseType

The type of license to assign to the group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Express, Advanced, Stakeholder, Professional, EarlyAdopter

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectGroupType

The type of access to grant in the project.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: projectReader, projectContributor, projectAdministrator, projectStakeholder

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectId

The ID of the project to grant access to.

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

### -LicensingSource

The source of licensing. Currently only supports 'account'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: account

Required: False
Position: Named
Default value: account
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization

The Azure DevOps organization.

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

### -Wait

If specified, waits for the operation to complete before returning.

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
