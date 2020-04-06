Function Show-Message {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true)][string]$Message
    )

    Write-Host $Message
}