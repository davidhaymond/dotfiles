#Requires -Version 6.0

Push-Location -Path ~\.dotfiles

# Update dotfiles repo
git pull -q --ff-only
if ($LASTEXITCODE -ne 0) {
    "`e[33mUnable to update dotfiles without merging.`e[0m"
}

$dotfiles = @(
    @{
        Target = ".dotfiles\gitconfig"
        Link   = "~\.gitconfig"
    },
    @{
        Target = ".dotfiles\vimrc"
        Link   = "~\_vimrc"
    },
    @{
        Target = "..\..\.dotfiles\pwsh-profile.ps1"
        Link   = $PROFILE
    }
    @{
        Target = "..\..\..\..\.dotfiles\vscode-settings.json"
        Link   = "$env:AppData\Code\User\settings.json"
    }
)

# Symlink dotfiles
$dotfiles | ForEach-Object -Process {
    # If the link path exists and isn't already a symlink, back up the file
    if ((Test-Path -Path $_) -and (Get-Item -Path $_).LinkType -ne "SymbolicLink") {
        $dotfile = Get-Item -Path $Path
        $backupPath = $dotfile.Name + '.bak'
        $dotfile | Rename-Item -NewName $backupPath -Force
    }
    New-Item -ItemType SymbolicLink -Path $_.Link -Target $_.Target -Force | Out-Null
}

Pop-Location
