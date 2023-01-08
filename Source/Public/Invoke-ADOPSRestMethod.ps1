function Invoke-ADOPSRestMethod {
    [SkipTest('HasOrganizationParameter')]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,

        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'Get',

        [Parameter()]
        [string]$Body
    )

    $InvokeSplat = @{
        Uri = $Uri
        Method = $Method
    }

    if (-Not [String]::IsNullOrEmpty($Body)) {
        $InvokeSplat.Add('Body', $Body)
    }

    InvokeADOPSRestMethod @InvokeSplat
}