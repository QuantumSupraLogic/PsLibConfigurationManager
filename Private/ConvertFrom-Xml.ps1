Set-StrictMode -Version 3.0

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