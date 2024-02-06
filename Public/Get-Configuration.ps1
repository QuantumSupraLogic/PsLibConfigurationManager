Set-StrictMode -Version 3.0

function Get-Configuration {
    param(
        # path to configuration file. must be in xml or json format
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $configurationFile
    )

    if (-Not (Test-Path -Path $configurationFile)) {
        throw (New-Object System.IO.FileNotFoundException("Configuration file not found: $configurationFile", $configurationFile))
    }

    switch ([System.IO.Path]::GetExtension($configurationFile)) {
        '.json' {
            $config = Get-Content -Path $configurationFile -Raw | ConvertFrom-Json
        }
        '.xml' {
            $config = Get-Content -Path $configurationFile -Raw | ConvertFrom-Xml
        }
        default {
            throw ("ConfigurationManager: config file format" + [System.IO.Path]::GetExtension($configurationFile) + "for file $configurationFile not supported. Use json or xml.")
        }
    }
    return $config
}