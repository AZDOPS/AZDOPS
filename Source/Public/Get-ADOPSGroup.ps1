function Get-ADOPSGroup {
    param ([Parameter()]
        [string]$Organization,

        [Parameter()]
        [string]
        $Descriptor,

        [Parameter(DontShow)]
        [string]$ContinuationToken
    )
    
    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    if ($PSBoundParameters.ContainsKey('Descriptor')) {
        $Uri = "https://vssps.dev.azure.com/$Organization/_apis/graph/groups/$Descriptor`?api-version=7.2-preview.1"

        $Response = InvokeADOPSRestMethod -Uri $Uri -Method 'GET'

        return $Response
    }
    else {
        if (-not [string]::IsNullOrEmpty($ContinuationToken)) {
            $Uri = "https://vssps.dev.azure.com/$Organization/_apis/graph/groups?continuationToken=$ContinuationToken&api-version=7.1-preview.1"
        }
        else {
            $Uri = "https://vssps.dev.azure.com/$Organization/_apis/graph/groups?api-version=7.1-preview.1"
        }
    }
    
    $Method = 'GET'

    $Response = InvokeADOPSRestMethod -FullResponse -Uri $Uri -Method $Method

    $Groups = $Response.Content.value
    Write-Verbose "Found $($Response.Content.count) groups"

    if ($Response.Headers.ContainsKey('X-MS-ContinuationToken')) {
        Write-Verbose "Found continuationToken. Will fetch more groups."
        $parameters = [hashtable]$PSBoundParameters
        $parameters.Add('ContinuationToken', $Response.Headers['X-MS-ContinuationToken']?[0])
        $Groups += Get-ADOPSGroup @parameters
    }
    
    Write-Output $Groups
}