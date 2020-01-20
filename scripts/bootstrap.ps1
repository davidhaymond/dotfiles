if ($IsLinux) {
    throw "This script supports Windows only. To install dotfiles on Linux, run `"curl https://setup.davidhaymond.dev | bash`"."
}
elseif ($IsMacOS) {
    throw "This script supports Windows only. This dotfiles repo is not yet supported on macOS."
}

# Temporarily allow scripts to run so scoop can install
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Clear .gitconfig to avoid Git errors
if (Test-Path -Path ~\.gitconfig) {
    if ((Get-Item -Path ~\.gitconfig).LinkType -eq 'SymbolicLink') {
        Remove-Item -Path ~\.gitconfig -Force
    }
    else {
        Rename-Item -Path ~\.gitconfig -NewName .gitconfig.bak -Force
    }
}

# Install scoop if needed
$isScoopInstalled = Test-Path -Path ~\scoop\apps\scoop\current\bin\scoop.ps1
if (!$isScoopInstalled) {
    Invoke-RestMethod -Uri get.scoop.sh | Invoke-Expression
}

# Install aria2 to speed up downloads on older versions of PowerShell
if ($PSEdition -ne 'Core') {
    scoop install aria2
}

# Install core packages required for adding custom buckets
scoop install git

# Add buckets
scoop bucket add extras
scoop bucket add david https://github.com/davidhaymond/scoop-bucket.git

# Update scoop
scoop update
scoop update *

# Install additional packages
scoop install gpmdp hyper keepass-pps lmir-tech-console nodejs telegram vim vimtutor vscode etcher

# Uninstall aria2 to revert to scoop's built-in download client
if ($PSEdition -ne 'Core') {
    scoop uninstall aria2
}

# Add Visual Studio Code context menu option to Windows Explorer
$regPath = Resolve-Path -Path ~\scoop\apps\vscode\current\vscode-install-context.reg
reg.exe import $regPath

# Clone dotfiles repo
$isDotfilesInstalled = Test-Path -Path ~\.dotfiles -PathType Container
if (!$isDotfilesInstalled) {
    Push-Location -Path ~
    git clone https://github.com/davidhaymond/dotfiles.git .dotfiles
    $dotfilesDir = Get-Item -Path .dotfiles -Force
    $dotfilesDir.Attributes = $dotfilesDir.Attributes -bor [System.IO.FileAttributes]::Hidden
    Set-Location -Path .dotfiles
    git remote set-url --push origin git@github.com:davidhaymond/dotfiles.git
}
else {
    Push-Location -Path ~\.dotfiles
    git pull
}

# Run global initialization script
$adminSetupPath = Resolve-Path -Path .\scripts\admin-setup.ps1
$adminSetupArgs = "-NoProfile -File `"$adminSetupPath`""
$adminProcess = Start-Process -FilePath powershell.exe -ArgumentList $adminSetupArgs -Verb RunAs -Wait -PassThru

# Creating symlinks without admin privileges is only supported in
# PowerShell 6 or later.
if ($PSEdition -eq 'Core') {
    .\scripts\install.ps1
}
else {
    $installPath = Resolve-Path -Path .\scripts\install.ps1
    $installArgs = "-nop -f `"$installPath`""
    Start-Process -FilePath pwsh-preview.cmd -ArgumentList $installArgs -NoNewWindow -Wait
}

if ($adminProcess.ExitCode -eq 3010) {
    $finishSetupPath = Resolve-Path -Path .\scripts\finish-setup.ps1
    $regParams = @{
        Path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce'
        Name = 'Finish dotfiles installation'
        Value = "pwsh-preview.cmd -NoProfile -File `"$finishSetupPath`""
    }
    Set-ItemProperty @regParams

    Write-Information -MessageData "Restarting in 5 seconds..." -InformationAction Continue
    Start-Sleep -Seconds 5
    Restart-Computer
}
else {
    .\scripts\finish-setup.ps1
}
Pop-Location
