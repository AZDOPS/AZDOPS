function Get-ADOPSArtifactFeed {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'FeedId', Mandatory)]
        [string]$Project,
        
        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'FeedId')]
        [string]$Organization,

        [Parameter(ParameterSetName = 'FeedId', Mandatory)]
        [Alias('Name')]
        [string]$FeedId
    )
    
    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }
    
    $Uri = "https://feeds.dev.azure.com/${Organization}"
    if (-not ([string]::IsNullOrEmpty($Project))) {
        $Uri = "${Uri}/${Project}"
    }
    $Uri = "${Uri}/_apis/packaging/feeds"
        if (-not ([string]::IsNullOrEmpty($FeedId))) {
        $Uri = "${Uri}/${FeedId}"
    }
    $Uri = "${Uri}?api-version=7.2-preview.1"
    
    $Method = 'Get'

    $InvokeSplat = @{
        Uri = $Uri
        Method = $Method
    }

    $res = InvokeADOPSRestMethod @InvokeSplat
    if ( 
        (($res | Get-Member -MemberType NoteProperty).Name -contains 'count') -and 
        (($res | Get-Member -MemberType NoteProperty).Name -contains 'value')
    ) {
        Write-Output $res.value -NoEnumerate
    }
    else {
        Write-Output $res
    }
}