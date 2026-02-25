---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSTenantPolicy

## SYNOPSIS
Retrieves the tenant policy for Azure DevOps.

## SYNTAX
```
Get-ADOPSTenantPolicy [-Parameter1 <Type>] [-Parameter2 <Type>] [<CommonParameters>]
```

## DESCRIPTION
The `Get-ADOPSTenantPolicy` cmdlet retrieves the tenant policy settings for Azure DevOps. This cmdlet can be used to obtain information about the current policies applied to the tenant.

## PARAMETERS

### -Parameter1  
Description of Parameter1.

### -Parameter2  
Description of Parameter2.

### -Organization  
Specifies the Azure DevOps organization to retrieve the tenant policy for.

### -PolicyCategory  
Specifies the category of the policy to retrieve. Valid values are:
- RestrictGlobalPersonalAccessToken
- RestrictPersonalAccessTokenLifespan
- EnableLeakedPersonalAccessTokenAutoRevocation
- OrganizationCreationRestriction
- RestrictFullScopePersonalAccessToken

### -Force  
Allows the cmdlet to execute, as it's using unsupported endpoints in Azure DevOps.

## EXAMPLES

### Example 1
```
Get-ADOPSTenantPolicy -Organization "MyOrganization" -PolicyCategory "RestrictGlobalPersonalAccessToken"
```
Retrieves the tenant policy for the specified organization and policy category.

### Example 2
```
Get-ADOPSTenantPolicy -Organization "MyOrganization" -PolicyCategory "RestrictPersonalAccessTokenLifespan"
```
Retrieves the tenant policy for the specified organization and policy category.

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

