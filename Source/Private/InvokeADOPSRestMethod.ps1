function InvokeADOPSRestMethod {
    param (
        [Parameter(Mandatory)]
        [URI]$Uri,

        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method,

        [Parameter()]
        [string]$Body,

        [Parameter()]
        [string]$Organization,

        [Parameter()]
        [string]$ContentType = 'application/json',

        [Parameter()]
        [switch]$FullResponse,

        [Parameter()]
        [string]$OutFile
    )

    $Token = NewAzToken

    $InvokeSplat = @{
        'Uri' = $Uri
        'Method' = $Method
        'Headers' = @{
            'Authorization' = "Bearer $Token"
        }
        'ContentType' = $ContentType
    }

    if (-not [string]::IsNullOrEmpty($Body)) {
        $InvokeSplat.Add('Body', $Body)
    }

    if ($FullResponse) {
        $InvokeSplat.Add('ResponseHeadersVariable', 'ResponseHeaders')
        $InvokeSplat.Add('StatusCodeVariable', 'ResponseStatusCode')
    }

    if ($OutFile) {
        Invoke-RestMethod @InvokeSplat -OutFile $OutFile
    }
    else {
        $Result = Invoke-RestMethod @InvokeSplat

        if ($Result -like "*Azure DevOps Services | Sign In*") {
            throw 'Failed to call Azure DevOps API. Please login before using.'
        }
        elseif ($FullResponse) {
            @{ Content = $Result; Headers = $ResponseHeaders; StatusCode = $ResponseStatusCode }
        }
        else {
            $Result
        }
    }
}
