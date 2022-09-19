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

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $OrgInfo = GetADOPSHeader -Organization $Organization
    }
    else {
        $OrgInfo = GetADOPSHeader
        $Organization = $OrgInfo['Organization']
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