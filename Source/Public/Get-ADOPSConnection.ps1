function Get-ADOPSConnection {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization
    )
    
    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Script:ADOPSCredentials.GetEnumerator() | Where-Object { $_.Key -eq $Organization}
    }
    else {
        $Script:ADOPSCredentials
    }
}