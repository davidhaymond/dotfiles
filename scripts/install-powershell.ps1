#Requires -RunAsAdministrator

# Install the latest version of PowerShell
Invoke-Expression "& { $(Invoke-RestMethod -Uri https://aka.ms/install-powershell.ps1) } -UseMSI -AddExplorerContextMenu -Quiet"
