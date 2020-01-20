#Requires -RunAsAdministrator
#Requires -Version 6.0

# Allow PowerShell to run scripts
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force -ErrorAction SilentlyContinue

# Remap keyboard:
#
# - Caps Lock -> Control
# - Insert -> Caps Lock
[byte[]]$map = 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
               0x07,0x00,0x00,0x00,0x1d,0x00,0x3a,0x00,
               0x1d,0xe0,0x2a,0xe0,0x1d,0xe0,0x37,0xe0,
               0x1d,0xe0,0x54,0x00,0x3a,0x00,0x52,0xe0,
               0x22,0xe0,0x45,0x00,0x00,0x00,0x00,0x00
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout' -Name 'Scancode Map' -Value $map | Out-Null

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


# Install the Windows Subsystem for Linux
$result = Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
if ($result.RestartNeeded) {
    exit 3010
}
