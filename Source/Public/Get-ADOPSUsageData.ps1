function Get-ADOPSUsageData {
    param(
        [Parameter()]
        [ValidateSet('Private','Public')]
        [string]$ProjectVisibility = 'Public',

        [Parameter()]
        [Switch]$SelfHosted,

        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    if ($SelfHosted.IsPresent) {
        $Hosted = $false
    }
    else {
        $Hosted = $true
    }

    $URI = "https://dev.azure.com/$Organization/_apis/distributedtask/resourceusage?parallelismTag=${ProjectVisibility}&poolIsHosted=${Hosted}&includeRunningRequests=true"
    $Method = 'Get'
    
    $InvokeSplat = @{
        Method       = $Method
        Uri          = $URI
        Organization = $Organization
    }

    InvokeADOPSRestMethod @InvokeSplat
}