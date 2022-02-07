function InvokeAZDevOPSRestMethod {
    param (
        [Parameter(Mandatory)]
        [URI]$uri,

        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$method,

        [Parameter()]
        [string]$Body,

        [Parameter()]
        [string]$Organization
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $CallHeaders = GetAZDevOPSHeader -Organization $Organization
    }
    else {
        $CallHeaders = GetAZDevOPSHeader
    }

    $InvokeSplat = @{
        'Uri' = $uri
        'Method' = $method
        'Headers' = $CallHeaders.Header
        'ContentType' = 'application/json'
    }

    if (-not [string]::IsNullOrEmpty($Body)) {
        $InvokeSplat.Add('Body', $body)
    }
    
    $result = Invoke-RestMethod @InvokeSplat

    if ($result -like "*Azure DevOps Services | Sign In*") {
        throw 'Failed to call Azure DevOps API. Please login before using.'
    }
    else {
        $result
    }
}