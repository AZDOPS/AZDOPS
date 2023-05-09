function SetADOPSConfigFile {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$ConfigPath = (Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'adops.config.json'),

        [Parameter(ValueFromPipeline)]
        [object]$ConfigObject
    )

    Set-Content -Path $ConfigPath -Value ($ConfigObject | ConvertTo-Json -Compress) -Force
}