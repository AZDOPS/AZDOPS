function Set-ADOPSProject {
    [CmdletBinding(DefaultParameterSetName = 'ProjectName')]
    param (    
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization,
        
        [Parameter(Mandatory, ParameterSetName = 'ProjectId')]
        [ValidateScript({
            [guid]::Parse($_)
        }, ErrorMessage = 'ProjectID format is wrong.')]
        [string]$ProjectId,
        
        [Parameter(Mandatory, ParameterSetName = 'ProjectName')]
        [ValidateNotNullOrEmpty()]
        [Alias('Project', 'Name')]
        [string]$ProjectName,

        [Parameter()]
        [string]$Description,
        
        [Parameter()]
        [ValidateSet('Private', 'Public')]
        [string]$Visibility,
        
        [Parameter()]
        [switch]$Wait
    )

    if (-Not ($PSBoundParameters.ContainsKey('Description')) -and -Not ($PSBoundParameters.ContainsKey('Visibility'))) {
        Write-Verbose 'Nothing to update. Exiting.'
    }
    else {
        # If user didn't specify org, get it from saved context
        if ([string]::IsNullOrEmpty($Organization)) {
            $Organization = GetADOPSDefaultOrganization
        }

        if ($PSCmdlet.ParameterSetName -eq 'ProjectName') {
            $ProjectId = Get-ADOPSProject -Name $ProjectName | Select-Object -ExpandProperty id
        }

        $uri = "https://dev.azure.com/${Organization}/_apis/projects/${ProjectId}?api-version=7.2-preview.4"

        
        $body = [ordered]@{}
        
        if ($PSBoundParameters.ContainsKey('Description')) {
            $body.Add('description', $Description)
        }

        if (-not [string]::IsNullOrEmpty($Visibility)) {
            $body.Add('visibility', $Visibility.ToLower())
        }
            
        $body = $body | ConvertTo-Json -Compress

        $InvokeSplat = [ordered]@{
            'Uri' = $uri
            'Method' = 'Patch'
            'Body' = $body
        }

        $res = InvokeADOPSRestMethod @InvokeSplat

        if ($PSBoundParameters.ContainsKey('Wait')) {
            $i = 0
            while (($res.status -notin @('cancelled', 'failed', 'succeeded')) -and $i -le 20) {
                $res = InvokeADOPSRestMethod -Uri $res.url -Method Get
                $i++
                Start-Sleep -Seconds 1
            }
            if ($i -ge 20) {
                Write-Verbose 'Status still not complete, failed, or canceled. Please verify project update.'
            }
        }

        $res
    }
}