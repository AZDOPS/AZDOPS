function Get-ADOPSMembership {
    param ([Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [string]
        $Descriptor,

        # The default value for direction is 'up' meaning return all memberships where the subject is a member (e.g. all groups the subject is a member of). Alternatively, passing the direction as 'down' will return all memberships where the subject is a container (e.g. all members of the subject group).
        [Parameter()]
        [string]
        [ValidateSet('up','down')]
        $Direction = 'up'
    )
    
    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://vssps.dev.azure.com/$Organization/_apis/graph/Memberships/$Descriptor`?direction=$Direction&depth=1&api-version=7.2-preview.1"
    $Response = InvokeADOPSRestMethod -Uri $Uri -Method 'GET'

    $Response.value.memberDescriptor | ForEach-Object -begin {
        $Members = New-object System.Collections.ArrayList
    } -process {
        $MemberType = ($_).split('.')[0]
        $Identity = $_
        switch ($MemberType) {
            'aadgp' {
                Get-ADOPSGroup -Descriptor $Identity | ForEach-Object { $Members.Add($_) | Out-Null }
            }
            'vssgp' {
                Get-ADOPSGroup -Descriptor $Identity | ForEach-Object { $Members.Add($_) | Out-Null }
            }
            'aad' {
                Get-ADOPSUser -Descriptor $Identity | ForEach-Object { $Members.Add($_) | Out-Null }
            }
        }
    }

    Write-Output $Members
}