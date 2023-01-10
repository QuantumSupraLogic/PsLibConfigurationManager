#region documentation
# import config files using xml or json format
#endregion

#region scriptheader
#requires -version 3.0
#endregion

#region code
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
function ConvertFrom-Xml($XML) {
    throw (New-Object System.NotImplementedException)
    foreach ($Object in @($XML.Objects.Object)) {
        $PSObject = New-Object PSObject
        foreach ($Property in @($Object.Property)) {
            $PSObject | Add-Member NoteProperty $Property.Name $Property.InnerText
        }
        $PSObject
    }
}
#endregion
