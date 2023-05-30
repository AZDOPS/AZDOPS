function SetADOPSConfigFile {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$ConfigPath = '~/.ADOPS/Config.json',

        [Parameter(ValueFromPipeline)]
        [object]$ConfigObject
    )

    $null = New-Item -Path '~/.ADOPS/' -ItemType Directory -ErrorAction SilentlyContinue
    Set-Content -Path $ConfigPath -Value ($ConfigObject | ConvertTo-Json -Compress) -Force
}