function Get-ADOPSUser {
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Name', Position = 0)]
        [string]$Name,
        [Parameter(Mandatory, ParameterSetName = 'Descriptor', Position = 0)]
        [string]$Descriptor,
        [Parameter()]
        [string]$Organization
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    }
    else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    if($PSCmdlet.ParameterSetName -eq 'Name') {
        $Uri = "https://vsaex.dev.azure.com/$Organization/_apis/UserEntitlements?`$filter=name eq '$Name'&`$orderBy=name Ascending&api-version=6.0-preview.3"
        $Method = 'GET'
        $Users = (InvokeADOPSRestMethod -Uri $Uri -Method $Method -Organization $Organization).members.user
        Write-Output $Users
    } elseif ($PSCmdlet.ParameterSetName -eq 'Descriptor') {
        $Uri = "https://vssps.dev.azure.com/$Organization/_apis/graph/users/$Descriptor`?api-version=6.0-preview.1"
        $Method = 'GET'
        $User = (InvokeADOPSRestMethod -Uri $Uri -Method $Method -Organization $Organization)
        Write-Output $User
    }
}