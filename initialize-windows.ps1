#Requires -RunAsAdministrator

# Allow PowerShell to run scripts
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force

# Enable Windows Developer Mode
$devModeRegParams = @{
    Path = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
    Name = "AllowDevelopmentWithoutDevLicense"
}
if (!(Test-Path -Path $devModeRegParams.Path)) {
    New-Item -Path $devModeRegParams.Path -Force | Out-Null
}
Set-ItemProperty @devModeRegParams -Value 1 | Out-Null

# Install the latest version of PowerShell (version 7 is currently behind the -Preview flag)
Invoke-Expression "& { $(Invoke-RestMethod -Uri https://aka.ms/install-powershell.ps1) } -UseMSI -Preview -AddExplorerContextMenu -Quiet"
