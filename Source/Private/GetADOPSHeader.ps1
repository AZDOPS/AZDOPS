function GetADOPSHeader {
    [CmdletBinding()]
    param (
        [string]$Organization
    )

    $Res = @{}

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $res.Add('Organization', $Organization)
    }
    else {
        $organizationResult = $script:ADOPSCredentials # Check if creds are set in this session
        
        if ($null -eq $organizationResult) {
            # If no cache is found see if persisant creds are set
            $SavePath = GetADOPSConfigPath
            if (Test-Path -Path $SavePath) {
                try {
                    $organizationResult = Get-Content $SavePath | ConvertTo-SecureString | ConvertFrom-SecureString -AsPlainText | ConvertFrom-Json -AsHashtable
                }
                catch {
                    throw 'Found persistant credentials, but failed to read them. Please recreate persistant store using Set-ADOPSConnection.'
                }
            }
            else {
                throw 'No default organization set. Please state organization, or use "Set-ADOPSConnection -DefaultOrganization $myOrg"'
            }
        }
        $res.Add('Organization', $organizationResult.Organization)
    }

    $token = NewAzToken
    $Header = @{
        Authorization = ("Bearer {0}" -f $token.token)
    }

    $Res.Add('Header',$Header)

    Write-Output $Res
}