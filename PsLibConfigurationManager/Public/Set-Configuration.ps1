
function Set-Configuration {
    param(
        # path to configuration file. must be in xml or json format
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $configurationFile,
        [Parameter(Mandatory = $true)]
        [PSObject]
        $config,
        [int]
        $depth
    )

    switch ([System.IO.Path]::GetExtension($configurationFile)) {
        '.json' {
            $config | ConvertTo-Json -Depth $depth | Out-File $configurationFile
        }
        default {
            throw ("ConfigurationManager: config file format" + [System.IO.Path]::GetExtension($configurationFile) + "for file $configurationFile not supported. Use json or xml.")
        }
    }
}