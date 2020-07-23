#Requires -Version 6.0

Push-Location -Path ~\.dotfiles
# Update dotfiles repo
git pull -q --ff-only
if ($LASTEXITCODE -ne 0) {
    "`e[33mUnable to update dotfiles without merging.`e[0m"
}

$dotfiles = @(
    @{
        Target = ".dotfiles\.gitconfig"
        Link   = "~\.gitconfig"
    },
    @{
        Target = ".dotfiles\.vimrc"
        Link   = "~\_vimrc"
    },
    @{
        Target = "..\..\.dotfiles\Profile.ps1"
        Link   = "~\Documents\PowerShell\Profile.ps1"
    }
    @{
        Target = "..\..\..\..\.dotfiles\windows-terminal-settings.json"
        Link   = "~\AppData\Local\Microsoft\Windows Terminal\settings.json"
    }
    @{
        Target = "..\..\..\..\.dotfiles\vscodium-settings.json"
        Link   = "$env:AppData\VSCodium\User\settings.json"
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

# Install and/or update plug.vim
$autoloadDir = "~\vimfiles\autoload"
$plugPath = Join-Path -Path $autoloadDir -ChildPath "plug.vim"
if (!(Test-Path -Path $plugPath)) {
    if (!(Test-Path -Path $autoloadDir)) {
        New-Item -ItemType Directory -Path $autoloadDir -Force | Out-Null
    }
    # Showing progress decreases download speed and adds visual clutter
    $prevProgPref = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -OutFile $plugPath
    $ProgressPreference = $prevProgPref
    Start-Sleep -Seconds 1
    vim -c "PlugInstall | quit | quit"
}
else {
    vim -c "PlugUpgrade | PlugUpdate | quit | quit"
}

Pop-Location
