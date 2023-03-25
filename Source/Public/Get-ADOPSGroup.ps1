function Get-ADOPSGroup {
    param ([Parameter()]
        [string]$Organization,

        [Parameter(DontShow)]
        [string]$ContinuationToken
    )
    
    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    }
    else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    
    if (-not [string]::IsNullOrEmpty($ContinuationToken)) {
        $Uri = "https://vssps.dev.azure.com/$Organization/_apis/graph/groups?continuationToken=$ContinuationToken&api-version=7.1-preview.1"
    }
    else {
        $Uri = "https://vssps.dev.azure.com/$Organization/_apis/graph/groups?api-version=7.1-preview.1"
    }
    
    $Method = 'GET'

    $Response = (InvokeADOPSRestMethod -FullResponse -Uri $Uri -Method $Method -Organization $Organization)

    $Groups = $Response.Content.value
    Write-Verbose "Found $($Response.Content.count) groups"

    if($Response.Headers.ContainsKey('X-MS-ContinuationToken')) {
        Write-Verbose "Found continuationToken. Will fetch more groups."
        $parameters = [hashtable]$PSBoundParameters
        $parameters.Add('ContinuationToken', $Response.Headers['X-MS-ContinuationToken']?[0])
        $Groups += Get-ADOPSGroup @parameters
    }
    
    Write-Output $Groups
}