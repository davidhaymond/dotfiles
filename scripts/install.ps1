#Requires -PSEdition Core

Push-Location -Path ~\.dotfiles
# Update dotfiles repo
git pull

$existingDotfiles = ""
$dotfiles = @(
    @{
        Target = "$PWD\.gitconfig"
        Link   = "~\.gitconfig"
    },
    @{
        Target = "$PWD\.vimrc"
        Link   = "~\_vimrc"
    },
    @{
        Target = "$PWD\Profile.ps1"
        Link   = "~\Documents\PowerShell\Profile.ps1"
    }
)

# Symlink dotfiles
$dotfiles | ForEach-Object -Process {
    # If the link path exists and isn't already a symlink, back up the file
    if ((Test-Path -Path $_) -and (Get-Item -Path $_).LinkType -ne "SymbolicLink") {
        $dotfile = Get-Item -Path $Path
        $backupPath = $dotfile.Name + '.bak'
        $dotfile | Rename-Item -NewName $backupPath -Force
        $existingDotfiles += "$Path -> $backupPath`n"
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
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -OutFile $plugPath -UseBasicParsing
    Start-Sleep -Seconds 2
    vim -c "PlugInstall | quit | quit"
}
else {
    vim -c "PlugUpgrade | PlugUpdate | quit | quit"
}

if ($backedUpDotfiles) {
    Write-Warning -Message "The following files were backed up:`n$backedUpDotfiles"
}
Pop-Location
Write-Information -MessageData "Installation/update completed. Profile updates will not take effect until PowerShell is restarted." -InformationAction Continue
