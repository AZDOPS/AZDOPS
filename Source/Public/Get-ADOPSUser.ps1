function Get-ADOPSUser {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Name', Position = 0)]
        [string]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Descriptor', Position = 0)]
        [string]$Descriptor,

        [Parameter()]
        [string]$Organization,

        [Parameter(ParameterSetName = 'Default', DontShow)]
        [string]$ContinuationToken
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    if ($PSCmdlet.ParameterSetName -eq 'Default') {
        $Uri = "https://vssps.dev.azure.com/$Organization/_apis/graph/users?api-version=6.0-preview.1"
        $Method = 'GET'
        if(-not [string]::IsNullOrEmpty($ContinuationToken)) {
            $Uri += "&continuationToken=$ContinuationToken"
        }
        $Response = (InvokeADOPSRestMethod -FullResponse -Uri $Uri -Method $Method -Organization $Organization)
        $Users = $Response.Content.value
        Write-Verbose "Found $($Response.Content.count) users"

        if($Response.Headers.ContainsKey('X-MS-ContinuationToken')) {
            Write-Verbose "Found continuationToken. Will fetch more users."
            $parameters = [hashtable]$PSBoundParameters
            $parameters.Add('ContinuationToken', $Response.Headers['X-MS-ContinuationToken']?[0])
            $Users += Get-ADOPSUser @parameters
        }   
        Write-Output $Users
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'Name') {
        $Uri = "https://vsaex.dev.azure.com/$Organization/_apis/UserEntitlements?`$filter=name eq '$Name'&`$orderBy=name Ascending&api-version=6.0-preview.3"
        $Method = 'GET'
        $Users = (InvokeADOPSRestMethod -Uri $Uri -Method $Method -Organization $Organization).members.user
        Write-Output $Users
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'Descriptor') {
        $Uri = "https://vssps.dev.azure.com/$Organization/_apis/graph/users/$Descriptor`?api-version=6.0-preview.1"
        $Method = 'GET'
        $User = (InvokeADOPSRestMethod -Uri $Uri -Method $Method -Organization $Organization)
        Write-Output $User
    }
}