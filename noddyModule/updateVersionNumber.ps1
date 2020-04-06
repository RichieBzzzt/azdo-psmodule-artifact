param(
    $versionNumber 
)
$manifest = Import-PowerShellDataFile .\noddyModule.psd1 
[version]$version = $Manifest.ModuleVersion
if ([string]::IsNullorEmpty( $versionNumber)) {
    $versionNumber = $Version.Build + 1
}
[version]$NewVersion = "{0}.{1}.{2}" -f $Version.Major, $Version.Minor, $versionNumber
Update-ModuleManifest -Path .\noddyModule.psd1 -ModuleVersion $NewVersion