---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSAuditStream

## SYNOPSIS
Sets up an audit stream from Azure DevOps to supported external logging services.

## SYNTAX

### AzureMonitorLogs (Default)
```
New-ADOPSAuditStream [-Organization <String>] -WorkspaceId <String> -SharedKey <String> [<CommonParameters>]
```

### Splunk
```
New-ADOPSAuditStream [-Organization <String>] -SplunkUrl <String> -SplunkEventCollectorToken <String>
 [<CommonParameters>]
```

### AzureEventGrid
```
New-ADOPSAuditStream [-Organization <String>] -EventGridTopicHostname <String>
 -EventGridTopicAccessKey <String> [<CommonParameters>]
```

## DESCRIPTION
This command sets up a log stream from Azure DevOps to an external supported service.
It only sets up log forwarding.
You need to enable logging separately from this command.
(Organization settings -> Policies -> Log audit events)

Supported services are
- Azure Monitor
- Splunk
- Azure Event grid

## EXAMPLES

### Example 1
```powershell
PS C:\> New-ADOPSAuditStream -WorkspaceId "11111111-1111-1111-1111-111111111111" -SharedKey "123456"
```

This command sets up log forwarding to Azure Monitor using the workspace id '11111111-1111-1111-1111-111111111111' and the shared key '123456'

### Example 2
```powershell
PS C:\> New-ADOPSAuditStream -SplunkUrl 'http://Splunkurl' -SplunkEventCollectorToken '11111111-1111-1111-1111-111111111111'
```

This command sets up log forwarding to splunk using the token '11111111-1111-1111-1111-111111111111' and the splunk url 'http://Splunkurl'

### Example 3
```powershell
PS C:\> $Bytes = [System.Text.Encoding]::Unicode.GetBytes('EventGridTopicAccessKey')
PS C:\> $Base64 =[Convert]::ToBase64String($Bytes)
PS C:\> New-ADOPSAuditStream -EventGridTopicHostname 'http://eventgridUri' -EventGridTopicAccessKey $Base64
```

This command sets up log forwarding to Azure eventgrid using the hostname 'http://eventgridUri' and the access key 'EventGridTopicAccessKey'
Access key must be base64 encoded.

## PARAMETERS

### -EventGridTopicAccessKey
Access key to Azure Eventgrid

```yaml
Type: String
Parameter Sets: AzureEventGrid
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventGridTopicHostname
Azure Eventgrid host to send logs to.
Must start with 'http://' or 'https://'

```yaml
Type: String
Parameter Sets: AzureEventGrid
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
The organization to set up forwarding from.

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

### -SharedKey
Azure Monitor shared access key

```yaml
Type: String
Parameter Sets: AzureMonitorLogs
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SplunkEventCollectorToken
Splunk event collector token.
Must be in GUID format.

```yaml
Type: String
Parameter Sets: Splunk
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SplunkUrl
URL to Splunk log host.
Must start with 'http://' or 'https://'

```yaml
Type: String
Parameter Sets: Splunk
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkspaceId
Azure monitor workspace ID.
Must be in GUID format.

```yaml
Type: String
Parameter Sets: AzureMonitorLogs
Aliases:

Required: True
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
