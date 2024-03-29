function New-ADOPSArtifactFeed {
    param (    
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [Alias('UpstreamEnabled')]
        [switch]$IncludeUpstream
    )
    
    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://feeds.dev.azure.com/$Organization/$Project/_apis/packaging/feeds?api-version=7.2-preview.1"

    $body = [ordered]@{
        name = $name
        upstreamEnabled = $IncludeUpstream.IsPresent
        hideDeletedPackageVersions = $true
        project = @{
            visibility = 'Private'
        }
    }

    if (-not [string]::IsNullOrEmpty($Description)) {
        $body.Add('description', $Description)
    }

    if ($IncludeUpstream.IsPresent) {
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

    $users = Get-ADOPSUser
    $buildService = $users.Where({$_.displayName -eq "$Project build service ($Organization)"})
    if ($buildService.Count -eq 0) {
        Write-Verbose "Failed to find build service account. Not adding it as contributor."
    }
    else {
        $buildServiceDescriptorObject = invokeADOPSRestMethod -Uri "https://vssps.dev.azure.com/$Organization/_apis/Identities?identityIds=$($buildService.originId)" -Method Get
        $permissions = @(
            @{
                identityDescriptor = "$($buildServiceDescriptorObject.Descriptor.IdentityType);$($buildServiceDescriptorObject.Descriptor.Identifier)"
                role = 'contributor'
                identityId = $buildServiceDescriptorObject.Id
            }
        )
        $body.Add('permissions', $permissions)
    }

    $InvokeSplat = @{
        Uri = $Uri
        Method = 'Post'
        Body = $body | ConvertTo-Json -Compress
    }
    InvokeADOPSRestMethod @InvokeSplat
}