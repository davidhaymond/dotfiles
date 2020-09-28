# dotfiles
My personal dotfiles collection.

## Installation

##### Linux

```sh
curl -sSL https://raw.githubusercontent.com/davidhaymond/dotfiles/master/scripts/bootstrap.sh | bash
```


##### Windows

If PowerShell 6+ isn't already installed, open Windows PowerShell as admin and run:

```powershell
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -AddExplorerContextMenu -Quiet"
```

Then open PowerShell 6 as your own account (not admin) and bootstrap the dotfiles:

```pwsh
irm https://raw.githubusercontent.com/davidhaymond/dotfiles/master/scripts/bootstrap.ps1 | iex
```
