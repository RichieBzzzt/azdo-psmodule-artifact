try {
    Import-Module Pester -MinimumVersion 4.4.2
}
catch {
    Update-Module Pester -MinimumVersion 4.4.2 -Scope CurrentUser -SkipPublisherCheck -Force
}

Set-Location $PSScriptRoot
$Edition = $PSVersionTable.PSEdition
$date = Get-Date -format "yyyy.MM.dd.hh.mm.ss"
Write-Host "Running tests..."
Invoke-Pester -Script @{Path = "./*.tests.ps1" } -OutputFile "TestResults-$Edition-$date.xml" -OutputFormat NUnitXML
