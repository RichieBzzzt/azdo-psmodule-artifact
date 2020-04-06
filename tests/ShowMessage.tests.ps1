Import-Module (Join-Path $PSScriptRoot "..\noddyModule") -Force

Describe "Show-Message" {
    It "Show-Message does not throw" {
        Show-Message -Message "Hello"
    }
}
