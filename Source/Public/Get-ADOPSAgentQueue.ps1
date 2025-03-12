function Get-ADOPSAgentQueue {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter()]
        [string]$QueueName
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }
    
    
    if ($PSBoundParameters.ContainsKey('QueueName')) {
        $Uri = "https://dev.azure.com/$Organization/$Project/_apis/distributedtask/queues?queueName=${QueueName}&api-version=7.1"
    } else {
        $Uri = "https://dev.azure.com/$Organization/$Project/_apis/distributedtask/queues?api-version=7.1"
    }
    
    $Method = 'GET'
    $Queue = InvokeADOPSRestMethod -Uri $Uri -Method $Method -Body $Body
    
    if ($Queue.psobject.properties.name -contains 'value') {
        Write-Output $Queue.value
    } else {
        Write-Output $Queue
    }
}