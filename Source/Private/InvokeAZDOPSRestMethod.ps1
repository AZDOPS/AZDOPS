function InvokeAZDOPSRestMethod {
    param (
        [Parameter(Mandatory)]
        [URI]$Uri,

        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method,

        [Parameter()]
        [string]$Body,

        [Parameter()]
        [string]$Organization
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $CallHeaders = GetAZDOPSHeader -Organization $Organization
    }
    else {
        $CallHeaders = GetAZDOPSHeader
    }

    $InvokeSplat = @{
        'Uri' = $Uri
        'Method' = $Method
        'Headers' = $CallHeaders.Header
        'ContentType' = 'application/json'
    }

    if (-not [string]::IsNullOrEmpty($Body)) {
        $InvokeSplat.Add('Body', $Body)
    }
    
    $Result = Invoke-RestMethod @InvokeSplat

    if ($Result -like "*Azure DevOps Services | Sign In*") {
        throw 'Failed to call Azure DevOps API. Please login before using.'
    }
    else {
        $Result
    }
}
