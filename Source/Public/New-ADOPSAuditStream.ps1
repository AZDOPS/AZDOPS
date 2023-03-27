function New-ADOPSAuditStream {
    [CmdletBinding(DefaultParameterSetName = 'AzureMonitorLogs')]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory, ParameterSetName = 'AzureMonitorLogs')]
        [ValidatePattern('^[a-fA-F0-9]{8}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{12}$', ErrorMessage = 'WorkspaceId should be in GUID format.')]
        [string]$WorkspaceId,

        [Parameter(Mandatory, ParameterSetName = 'AzureMonitorLogs')]
        [string]$SharedKey,

        [Parameter(Mandatory, ParameterSetName = 'Splunk')]
        [ValidatePattern('^(http|HTTP)[sS]?:\/\/', ErrorMessage = 'SplunkUrl must start with http:// or https://')]
        [string]$SplunkUrl,

        [Parameter(Mandatory, ParameterSetName = 'Splunk')]
        [ValidatePattern('^[a-fA-F0-9]{8}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{12}$', ErrorMessage = 'SplunkEventCollectorToken should be in GUID format.')]
        [string]$SplunkEventCollectorToken,

        [Parameter(Mandatory, ParameterSetName = 'AzureEventGrid')]
        [ValidatePattern('^(http|HTTP)[sS]?:\/\/', ErrorMessage = 'EventGridTopicHostname must start with http:// or https://')]
        [string]$EventGridTopicHostname,

        [Parameter(Mandatory, ParameterSetName = 'AzureEventGrid')]
        [ValidatePattern('^[A-Za-z0-9+\/]*={0,2}$', ErrorMessage = 'EventGridTopicAccessKey should be Base64 encoded')]
        [string]$EventGridTopicAccessKey
    )
    
    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    } else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    $Body = switch ($PSCmdlet.ParameterSetName) {
        'AzureMonitorLogs' { 
            [ordered]@{
                consumerType = 'AzureMonitorLogs'
                consumerInputs = [Ordered]@{
                    WorkspaceId = $WorkspaceId
                    SharedKey = $SharedKey
                }
            } | ConvertTo-Json -Compress
         }
        'Splunk' { 
            [ordered]@{
                consumerType = 'Splunk'
                consumerInputs = [Ordered]@{
                    SplunkUrl = $SplunkUrl
                    SplunkEventCollectorToken = $SplunkEventCollectorToken
                }
            } | ConvertTo-Json -Compress
         }
        'AzureEventGrid' { 
            [ordered]@{
                consumerType = 'AzureEventGrid'
                consumerInputs = [ordered]@{
                    EventGridTopicHostname = $EventGridTopicHostname
                    EventGridTopicAccessKey = $EventGridTopicAccessKey
                }
            } | ConvertTo-Json -Compress
         }
    }
    $InvokeSplat = @{
        Uri = "https://auditservice.dev.azure.com/$Organization/_apis/audit/streams?api-version=7.1-preview.1"
        Method = 'Post'
        Body = $Body
    }

    InvokeADOPSRestMethod @InvokeSplat
}
