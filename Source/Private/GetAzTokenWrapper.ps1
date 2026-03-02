function  GetAzTokenWrapper {
    param (
        $inputObject
    )
    try {
        Get-AzToken @inputObject
    }
    catch [System.PlatformNotSupportedException] {
        if (-not ($inputObject.ContainsKey('UseUnprotectedTokenCache'))) {
            try {
                Get-AzToken @inputObject -UseUnprotectedTokenCache
            }
            catch  {
                throw $_
            }
        }
        else {
            Write-Error "Failed to get token. $_"
        }
    }
    catch {
        Write-Error "Failed to get token. $_"
    }
}