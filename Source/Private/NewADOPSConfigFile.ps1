function NewADOPSConfigFile {
    param (
        [Parameter()]
        [string]$ConfigPath = (Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'adops.config.json')
    )

    @{
        'Default' = @{}
    } | SetADOPSConfigFile
}