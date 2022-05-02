function <%=$PLASTER_PARAM_CmdletName%> {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization
    )
    
    if (-not [string]::IsNullOrEmpty($Organization)) {
        $OrgInfo = GetADOPSHeader -Organization $Organization
    }
    else {
        $OrgInfo = GetADOPSHeader
        $Organization = $OrgInfo['Organization']
    }
    
    $Uri = ""
    
    $InvokeSplat = @{
        Method       = 'GET'
        Uri          = $URI
        Organization = $Organization
    }

    InvokeADOPSRestMethod @InvokeSplat
}
