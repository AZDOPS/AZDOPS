function Get-ADOPSPipelineTask {
    param (
        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Organization,

        [Parameter()]
        [int]$Version
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri =  "https://dev.azure.com/$Organization/_apis/distributedtask/tasks?api-version=7.1-preview.1"

    $result = InvokeADOPSRestMethod -Uri $Uri -Method Get

    $ReturnValue = $result | ConvertFrom-Json -AsHashtable | Select-Object -ExpandProperty value

    if (-Not [string]::IsNullOrEmpty($Name)) {
        $ReturnValue = $ReturnValue |  Where-Object -Property name -EQ $Name
    }
    if ($Version) {
        $ReturnValue = $ReturnValue |  Where-Object -FilterScript {$_.version.major -eq $Version}
    }

    $ReturnValue
}