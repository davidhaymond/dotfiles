# dotfiles
My personal config files with installation scripts for Linux and Windows.

## Installation

##### Linux

```sh
curl -sSL https://dotfiles.davidhaymond.dev/linux | bash
```


##### Windows

If PowerShell 6+ isn't already installed, open Windows PowerShell as admin and run:

```powershell
iwr https://dotfiles.davidhaymond.dev/pwsh | iex
```

Then open PowerShell 6 as your own account (not admin) and bootstrap the dotfiles:

```pwsh
iwr https://dotfiles.davidhaymond.dev/windows | iex
```
