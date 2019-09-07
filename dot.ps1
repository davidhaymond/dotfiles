param(
    [switch] $InitializeSystem
)

$devModeRegParams = @{
    Path = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
    Name = "AllowDevelopmentWithoutDevLicense"
}
$existingDotfiles = ""
$dotfiles = @(
    @{
        Target = "$PSScriptRoot\.gitconfig"
        Link   = "~\.gitconfig"
    },
    @{
        Target = "$PSScriptRoot\.vimrc"
        Link   = "~\_vimrc"
    }
)

function Test-IsAdmin {
    $myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $myWindowsPrincipal = New-Object -TypeName System.Security.Principal.WindowsPrincipal -ArgumentList $myWindowsID
    $adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    return $myWindowsPrincipal.IsInRole($adminRole)
}

function Test-SystemSetupDone {
    $devMode = Get-ItemProperty @devModeRegParams -ErrorAction SilentlyContinue
    if ($devMode -and $devMode.AllowDevelopmentWithoutDevLicense -eq 1) { return $true }
    return $false
}

if ($InitializeSystem) {
    if (Test-IsAdmin) {
        if (!(Test-Path -Path $devModeRegParams.Path)) {
            New-Item -Path $devModeRegParams.Path -Force | Out-Null
        }
        Set-ItemProperty @devModeRegParams -Value 1 | Out-Null
    } 
    else {
        Write-Error "Need to be running as admin to initialize the system."
    }
    exit
}

if (!(Test-SystemSetupDone)) {
    Write-Error "The system has not been initialized. Run 'dot.ps1 -InitializeSystem' as admin."
    exit
}

# Symlink dotfiles
$dotfiles | ForEach-Object -Process {
    # If the link path exists and isn't already a symlink, back up the file
    if ((Test-Path -Path $_) -and (Get-Item -Path $_).LinkType -ne "SymbolicLink") {
        $dotfile = Get-Item -Path $Path
        $backupPath = $dotfile.Name + '.bak'
        $dotfile | Rename-Item -NewName $backupPath -Force
        $existingDotfiles += "`n$Path -> $backupPath"
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
    vim -c "PlugInstall | quit | quit"
}
else {
    vim -c "PlugUpgrade | PlugUpdate | quit | quit"
}

if ($backedUpDotfiles) {
    Write-Warning -Message "The following files were backed up:`n$backedUpDotfiles"
}
