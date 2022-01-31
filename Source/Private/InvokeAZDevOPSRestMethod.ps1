function InvokeAZDevOPSRestMethod {
    param (
        [Parameter(Mandatory)]
        [URI]$uri,

        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$method,

        [Parameter()]
        [string]$Body
    )

    $CallHeaders = GetAZDevOPSHeader

    $InvokeSplat = @{
        'Uri' = $uri
        'Method' = $method
        'Headers' = $CallHeaders
    }

    if (-not [string]::IsNullOrEmpty($Body)) {
        $InvokeSplat.Add('Body', $body)
        $InvokeSplat.Add('ContentType', 'application/json')
    }
    
    Invoke-RestMethod @InvokeSplat
}