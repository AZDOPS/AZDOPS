function NewADOPSConfigFile {
    param (
        [Parameter()]
        [string]$ConfigPath = '~/.ADOPS/Config.json'
    )

    @{
        'Default' = @{}
    } | SetADOPSConfigFile
}