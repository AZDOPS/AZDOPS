function Connect-ADOPS {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = "PAT")]
        [ValidateNotNullOrEmpty()]
        [string]$Username,
        
        [Parameter(Mandatory, ParameterSetName = "PAT")]
        [ValidateNotNullOrEmpty()]
        [string]$PersonalAccessToken,

        [Parameter(Mandatory, ParameterSetName = 'OAuth2')]
        [ValidateNotNullOrEmpty()]
        [string]$TenantId,

        [Parameter(Mandatory, ParameterSetName = 'OAuth2')]
        [ValidateNotNullOrEmpty()]
        [string]$ClientId,
        
        [Parameter(ParameterSetName = 'OAuth2')]
        [ValidateNotNullOrEmpty()]
        [string]$RedirectUri = 'http://localhost:51235/',

        [Parameter(Mandatory, ParameterSetName = "PAT")]
        [ValidateNotNullOrEmpty()]
        [parameter(Mandatory, ParameterSetName = 'OAuth2')]
        [ValidateNotNullOrEmpty()]
        [string]$Organization,

        [Parameter(ParameterSetName = "PAT")]
        [parameter(ParameterSetName = 'OAuth2')]
        [switch]$Default
    )
    
    switch ($PSCmdlet.ParameterSetName) {

        'PAT' { 

            $Credential = [pscredential]::new($Username, (ConvertTo-SecureString -String $PersonalAccessToken -AsPlainText -Force))
            $ShouldBeDefault = $Default.IsPresent

            if ($script:ADOPSCredentials.Count -eq 0) {
                $ShouldBeDefault = $true
                $Script:ADOPSCredentials = @{}
            }
            elseif ($default.IsPresent) {
                $r = $script:ADOPSCredentials.Keys | Where-Object { $ADOPSCredentials[$_].Default -eq $true }
                $ADOPSCredentials[$r].Default = $false
            }

            $OrgData = @{
                Type       = "PAT"
                Credential = $Credential
                Default    = $ShouldBeDefault
            }
            
            $Script:ADOPSCredentials[$Organization] = $OrgData
        }

        'OAuth2' {

            Write-Host -ForegroundColor Yellow "Authenticate using the following Url: https://login.microsoftonline.com/$TenantId/oauth2/authorize?resource=499b84ac-1321-427f-aa17-267ca6975798&client_id=$ClientId&response_type=code&redirect_uri=$RedirectUri"

            try {
                $HttpListener = [System.Net.HttpListener]::new()
                $HttpListener.Prefixes.Add($RedirectUri)
                $HttpListener.Start()

                $Context = $HttpListener.GetContext()
                $Context.Response.StatusCode = 200
                $Context.Response.ContentType = 'text/html'
                $Response = 'You are now logged in. This window can be closed.'

                $AuthCode = $Context.Request.QueryString['code']

                $Context.Response.OutputStream.Write([System.Text.Encoding]::UTF8.GetBytes($Response), 0, $Response.Length)
                $context.Response.Close()
            }
            catch {
                Throw "Http listener failed with the following error: $_"
            }
            finally {
                try {
                    $HttpListener.Close()
                    $HttpListener.Dispose()
                }
                catch {
                    # do nothing
                }
            }

            $TokenBody = @{
                resource     = '499b84ac-1321-427f-aa17-267ca6975798'
                client_id    = $ClientId
                grant_type   = 'authorization_code'
                code         = $AuthCode
                redirect_uri = $RedirectUri
            }

            $Token = Invoke-RestMethod -Method POST -Uri "https://login.microsoftonline.com/$TenantId/oauth2/token" -Body $TokenBody -ErrorAction Stop

            $ShouldBeDefault = $Default.IsPresent

            if ($script:ADOPSCredentials.Count -eq 0) {
                $ShouldBeDefault = $true
                $Script:ADOPSCredentials = @{}
            }
            elseif ($Default.IsPresent) {
                $r = $script:ADOPSCredentials.Keys | Where-Object { $ADOPSCredentials[$_].Default -eq $true }
                $ADOPSCredentials[$r].Default = $false
            }

            $OrgData = @{
                Type        = "OAuth2"
                AccessToken = $Token.access_token
                Default     = $ShouldBeDefault
            }
            
            $Script:ADOPSCredentials[$Organization] = $OrgData
        
        }

    }

    # Test connection and return profile

    $URI = "https://vssps.dev.azure.com/$Organization/_apis/profile/profiles/me?api-version=7.1-preview.3"

    try {
        InvokeADOPSRestMethod -Method Get -Uri $URI
    }
    catch {
        $Script:ADOPSCredentials.Remove($Organization)
        throw $_
    }
}