try {
    Import-Module PsScriptAnalyzer
}
catch {
    Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
}
Write-Host "Running script analyzer..."
$noddyModule = Join-Path $PSScriptRoot "..\noddyModule"
Invoke-ScriptAnalyzer $noddyModule\* -Verbose