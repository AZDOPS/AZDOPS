---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Invoke-ADOPSRestMethod

## SYNOPSIS
Invoke a ADOPS rest API call.

## SYNTAX

```
Invoke-ADOPSRestMethod [-Uri] <String> [[-Method] <WebRequestMethod>] [[-Body] <String>] [-FullResponse] [<CommonParameters>]
```

## DESCRIPTION
This command invokes a API call to Azure DevOps using the standard ADOPS logged in account.
If you do not give the full Uri to call, for example 'https://dev.azure.com/myOrganization/_api/GetStuff', it will append 'https://dev.azure.com/$Organization', where $Organization is the one you are connected to, to your URI.

By default, only the parsed response body is returned. With -FullResponse, a successful request returns a hashtable containing Content, Headers, and StatusCode. Content is the parsed response body, Headers is the native response-header dictionary, and StatusCode is the numeric HTTP status code.

Header values are preserved without joining or flattening multiple values. This command makes one request; callers must implement any endpoint-specific pagination. Request failures and sign-in-page errors are propagated rather than returned as full-response objects.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-ADOPSRestMethod -Uri "https://dev.azure.com/$Organization/_apis/distributedtask/tasks"
```

This command will return whatever this API endpoint returns.

### Example 2
```powershell
PS C:\> Invoke-ADOPSRestMethod -Uri "/_apis/distributedtask/tasks"
```

This command will append 'https://dev.azure.com/$Organization' to URI and return whatever the full API endpoint 'https://dev.azure.com/$Organization/_apis/distributedtask/tasks' returns.

$Organization is taken from the current ADOPS connection. 

### Example 3
```powershell
PS C:\> Invoke-ADOPSRestMethod -Uri "https://dev.azure.com/$Organization/_apis/distributedtask/tasks" -Method Post -Body $BodyObject
```

This command will perform a Post call to the API endpoint. It will perform the API call using the logged in ADOPS credentials. It will include the body object in the call. It will _not_ format or validate any of the input values.

### Example 4
```powershell
PS C:\> $response = Invoke-ADOPSRestMethod -Uri "_apis/projects?api-version=7.1" -FullResponse
PS C:\> $response.Content
PS C:\> $response.StatusCode
PS C:\> $continuationTokens = @($response.Headers['x-ms-continuationtoken'])
```

Returns the body, response headers, and status for one request. The continuation header may be absent or contain multiple values; its values remain separate and opaque. Use the endpoint's documented paging rules to construct a subsequent request. This command does not follow continuation tokens automatically.

## PARAMETERS

### -Body
Body to include in the API call

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

### -Method
API method to use

```yaml
Type: WebRequestMethod
Parameter Sets: (All)
Aliases:
Accepted values: Default, Get, Head, Post, Put, Delete, Trace, Options, Merge, Patch

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FullResponse
Return a hashtable with Content, Headers, and StatusCode for a successful request instead of the response body alone. Headers retains the native header dictionary and multi-value header values. Empty responses still include all three keys. Omitting this switch or passing -FullResponse:$false preserves the body-only output.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Uri
Full Uri to call, including "https://dev.azure.com/organization"

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
Without -FullResponse, returns the parsed response body using the existing PowerShell pipeline behavior.

### System.Collections.Hashtable
With -FullResponse, returns one hashtable with Content (parsed body, which can be empty), Headers (native response-header dictionary with unmodified values), and StatusCode (numeric HTTP status). Failures throw; they do not produce this envelope.

## NOTES

## RELATED LINKS
