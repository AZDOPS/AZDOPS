function Set-ADOPSArtifactFeed {
    [CmdletBinding()]
    param (   
        [Parameter(Mandatory)]
        [string]$Project,
        
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [Alias('Name')]
        [string]$FeedId,
        
        [Parameter()]
        [string]$Description,
        
        [Parameter()]
        [Alias('IncludeUpstream')]
        [bool]$UpstreamEnabled
    )
 
    if (
        -not ($PSBoundParameters.ContainsKey('Description')) -and
        -not ($PSBoundParameters.ContainsKey('UpstreamEnabled'))
    ) {
        Write-Verbose 'Nothing to do. Exiting early'
    }
    else {
        # If user didn't specify org, get it from saved context
        if ([string]::IsNullOrEmpty($Organization)) {
            $Organization = GetADOPSDefaultOrganization
        }
        
        $Uri = "https://feeds.dev.azure.com/${Organization}/${Project}/_apis/packaging/feeds/${FeedId}?api-version=7.2-preview.1"
        $Method = 'Patch'

        $Body = [ordered]@{}
        if ($PSBoundParameters.ContainsKey('Description')) {
            $Body['description'] = $Description
        }
        if ($PSBoundParameters.ContainsKey('UpstreamEnabled')) {
            $Body['upstreamEnabled'] = $UpstreamEnabled
                if ($UpstreamEnabled -eq $true) {                
                $upstreamSources = @(
                    @{
                        name = "npmjs"
                        protocol = "npm"
                        location = "https://registry.npmjs.org/"
                        displayLocation = "https://registry.npmjs.org/"
                        upstreamSourceType = "public"
                        status = "ok"
                    }
                    @{
                        name = "NuGet Gallery"
                        protocol = "nuget"
                        location = "https://api.nuget.org/v3/index.json"
                        displayLocation = "https://api.nuget.org/v3/index.json"
                        upstreamSourceType = "public"
                        status = "ok"
                    }
                    @{
                        name = "PowerShell Gallery"
                        protocol = "nuget"
                        location = "https://www.powershellgallery.com/api/v2/"
                        displayLocation = "https://www.powershellgallery.com/api/v2/"
                        upstreamSourceType = "public"
                        status = "ok"
                    }
                    @{
                        name = "PyPI"
                        protocol = "pypi"
                        location = "https://pypi.org/"
                        displayLocation = "https://pypi.org/"
                        upstreamSourceType = "public"
                        status = "ok"
                    }
                    @{
                        name = "Maven Central"
                        protocol = "Maven"
                        location = "https://repo.maven.apache.org/maven2/"
                        displayLocation = "https://repo.maven.apache.org/maven2/"
                        upstreamSourceType = "public"
                        status = "ok"
                    }
                    @{
                        name = "Google Maven Repository"
                        protocol = "Maven"
                        location = "https://dl.google.com/android/maven2/"
                        displayLocation = "https://dl.google.com/android/maven2/"
                        upstreamSourceType = "public"
                        status = "ok"
                    }
                    @{
                        name = "JitPack"
                        protocol = "Maven"
                        location = "https://jitpack.io/"
                        displayLocation = "https://jitpack.io/"
                        upstreamSourceType = "public"
                        status = "ok"
                    }
                    @{
                        name = "Gradle Plugins"
                        protocol = "Maven"
                        location = "https://plugins.gradle.org/m2/"
                        displayLocation = "https://plugins.gradle.org/m2/"
                        upstreamSourceType = "public"
                        status = "ok"
                    }
                    @{
                        name = "crates.io"
                        protocol = "Cargo"
                        location = "https://index.crates.io/"
                        displayLocation = "https://index.crates.io/"
                        upstreamSourceType = "public"
                        status = "ok"
                    }
                )
                $body.Add('upstreamSources', $upstreamSources)
            }
        }

        $Body = $Body | ConvertTo-Json -Compress

        $InvokeSplat = @{
            Uri = $Uri
            Method = $Method
            Body = $Body
        }

        InvokeADOPSRestMethod @InvokeSplat
    }
}