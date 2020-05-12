#Requires -RunAsAdministrator
#Requires -Version 6.0

# Enable Windows Developer Mode
$devModeRegParams = @{
    Path = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
    Name = "AllowDevelopmentWithoutDevLicense"
    Value = 1
}
if (!(Test-Path -Path $devModeRegParams.Path)) {
    New-Item -Path $devModeRegParams.Path -Force | Out-Null
}
Set-ItemProperty @devModeRegParams | Out-Null
