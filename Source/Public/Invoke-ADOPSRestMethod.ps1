function Invoke-ADOPSRestMethod {
    [SkipTest('HasOrganizationParameter')]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,

        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'Get',

        [Parameter()]
        [string]$Body,

        [Parameter()]
        [switch]$FullResponse
    )

    If ( ($Uri -NotLike "*dev.azure.com*") -and ($Uri -NotLike "*visualstudio.com*")) {
        $Organization = GetADOPSDefaultOrganization
        $Uri = "https://dev.azure.com/$Organization/$Uri"
    }

    $InvokeSplat = @{
        Uri = $Uri
        Method = $Method
    }

    if (-Not [String]::IsNullOrEmpty($Body)) {
        $InvokeSplat.Add('Body', $Body)
    }

    if ($FullResponse) {
        $InvokeSplat.Add('FullResponse', $FullResponse)
    }

    InvokeADOPSRestMethod @InvokeSplat
}