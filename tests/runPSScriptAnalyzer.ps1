try {
    Import-Module PsScriptAnalyzer
}
catch {
    Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
}
Write-Host "Running script analyzer..."
Invoke-ScriptAnalyzer ..\noddyModule\*