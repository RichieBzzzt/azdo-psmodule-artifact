[CmdletBinding()]
param (
    [string]$packageSourceUrl,
    [string]$AzDOArtifactFeedName = 'artifact',
    [string]$AzDOPat,
    [string]$ModuleFolderPath = (Join-Path -Path $env:SYSTEM_ARTIFACTSDIRECTORY -ChildPath "_RichieBzzzt.azdo_psmodule_artifact\noddyModule")
)

# Variables
$feedUsername = 'NotChecked'

# This is downloaded during Step 3, but could also be "C:\Users\USERNAME\AppData\Local\Microsoft\Windows\PowerShell\PowerShellGet\NuGet.exe"
# if not running script as Administrator.
$nugetPath = (Get-Command NuGet.exe).Source
if (-not (Test-Path -Path $nugetPath)) {
    # $nugetPath = 'C:\ProgramData\Microsoft\Windows\PowerShell\PowerShellGet\NuGet.exe'
    $nugetPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath 'Microsoft\Windows\PowerShell\PowerShellGet\NuGet.exe'
}

# Create credential
$password = ConvertTo-SecureString -String $AzDOPat -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($feedUsername, $password)

Get-PackageProvider -Name 'NuGet' -ForceBootstrap | Format-List *


# Step 3
# THIS WILL FAIL first time, so don't panic!
# Try to Publish a PowerShell module - this will prompt and download NuGet.exe, and fail publishing the module (we publish at the end)
$publishParams = @{
    Path        = $ModuleFolderPath
    Repository  = $AzDOArtifactFeedName
    NugetApiKey = 'VSTS'
    Force       = $true
    Verbose     = $true
    Credential  = $credential
    ErrorAction = 'SilentlyContinue'
}
Publish-Module @publishParams


& $nugetPath Sources Add -Name $AzDOArtifactFeedName -Source $packageSourceUrl -Username $feedUsername -Password $AzDOPat

& $nugetPath Sources List

$registerParams = @{
    Name                      = $AzDOArtifactFeedName
    SourceLocation            = $packageSourceUrl
    PublishLocation           = $packageSourceUrl
    InstallationPolicy        = 'Trusted'
    PackageManagementProvider = 'Nuget'
    Credential                = $credential
    Verbose                   = $true
}

Write-Host "Trying to Register Repository..." 

Register-PSRepository @registerParams

Write-Host "Getting Repository..." 

Get-PSRepository -Name $AzDOArtifactFeedName

Write-Host "Publishing Module..."

Publish-Module @publishParams