#Requires -RunAsAdministrator
#Requires -Version 6.0

# Allow PowerShell to run scripts
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force -ErrorAction SilentlyContinue


# Install scoop if needed
$isScoopInstalled = Test-Path -Path ~\scoop\apps\scoop\current\bin\scoop.ps1
if (!$isScoopInstalled) {
    Invoke-RestMethod -Uri get.scoop.sh | Invoke-Expression
}

# Install core packages required for adding custom buckets
scoop install git

# Add buckets
scoop bucket add extras

# Update scoop
scoop update
scoop update *

# Install global scoop packages
scoop install vcredist2019 --global     # Windows Terminal prerequisite


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

# Enable the SSH Agent
Set-Service -Name ssh-agent -StartupType Manual


# Install the Windows Subsystem for Linux
$features = ('Microsoft-Windows-Subsystem-Linux', 'VirtualMachinePlatform')
$result = Enable-WindowsOptionalFeature -Online -FeatureName $features -NoRestart
if ($result.RestartNeeded) {
    exit 3010
}
