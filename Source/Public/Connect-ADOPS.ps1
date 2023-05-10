function Connect-ADOPS {
    [CmdletBinding(DefaultParameterSetName = 'Interactive')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Interactive')]
        [Parameter(Mandatory, ParameterSetName = 'ManagedIdentity')]
        [Parameter(Mandatory, ParameterSetName = 'Token')]
        [Parameter(Mandatory, ParameterSetName = 'OAuthToken')]
        [string]$Organization,
        
        [Parameter(ParameterSetName = 'Interactive')]
        [Parameter(ParameterSetName = 'ManagedIdentity')]
        [Parameter(ParameterSetName = 'Token')]
        [string]$TenantId,

        [Parameter(ParameterSetName = 'Interactive')]
        [switch]$Interactive,

        [Parameter(Mandatory, ParameterSetName = 'ManagedIdentity')]
        [switch]$ManagedIdentity,

        [Parameter(Mandatory, ParameterSetName = 'OAuthToken')]
        [String]$OAuthToken
    )
    
    $TokenSplat = @{
        Resource = '499b84ac-1321-427f-aa17-267ca6975798'
        Scope    = '.default'
    }

    # Add TenantId if provided
    if ($PSBoundParameters.ContainsKey('TenantId')) {
        $TokenSplat.Add('TenantId', $TenantId)
    }

    switch ($PSCmdlet.ParameterSetName) {
        'Token' {
            $script:LoginMethod = 'OAuthToken'
            $script:ScriptToken = $OAuthToken
            $Token = $OAuthToken
            $TokenTenantId = 'NotSet'
            $TokenIdentity = $null
            break
        }
        'ManagedIdentity' {
            $TokenSplat.Add('ManagedIdentity', $true)
            $script:LoginMethod = 'ManagedIdentity'

            $Token = Get-AzToken @TokenSplat
            $TokenTenantId = $Token.TenantId
            $TokenIdentity = $Token.Identity
        }
        'Interactive' {
            $TokenSplat.Add('TokenCache', $script:AzTokenCache)
            $TokenSplat.Add('Interactive', $true)

            $Token = Get-AzToken @TokenSplat
            $TokenTenantId = $Token.TenantId
            $TokenIdentity = $Token.Identity
        }
    }

    # Get User context
    $Me = Invoke-RestMethod -Method GET 'https://app.vssps.visualstudio.com/_apis/profile/profiles/me?api-version=7.1-preview.3' -Headers @{
        Authorization = "Bearer $Token"
    }

    # Get available orgs
    $Orgs = (Invoke-RestMethod -Method GET "https://app.vssps.visualstudio.com/_apis/accounts?memberId=$($Me.publicAlias)&api-version=7.1-preview.1" -Headers @{
            Authorization = "Bearer $Token"
        } | Select-Object -ExpandProperty value).accountName
    
    if ($Organization -notin $Orgs) {
        throw "The connected account does not have access to the organization '$Organization'"
    }

    # If user provided a token, we have not parsed the JWT for the email/id
    if ($null -eq $TokenIdentity) {
        # Instead take info from the DevOps response
        if (-not [string]::IsNullOrWhiteSpace($Me.emailAddress)) {
            $TokenIdentity = $Me.emailAddress 
        }
        else {
            $TokenIdentity = $Me.id
        }
    }
    $ADOPSConfig = GetADOPSConfigFile
    $ADOPSConfig['Default'] = @{
        'Identity'     = $TokenIdentity
        'TenantId'     = $TokenTenantId
        'Organization' = $Organization
    }

    SetADOPSConfigFile -ConfigObject $ADOPSConfig
    
    Write-Output $ADOPSConfig['Default']
}