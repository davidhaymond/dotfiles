#Requires -Version 6.0

if ($IsLinux) {
    throw "This script supports Windows only. To install dotfiles on Linux, run `"curl https://setup.davidhaymond.dev | bash`"."
}
elseif ($IsMacOS) {
    throw "This script supports Windows only. This dotfiles repo is not yet supported on macOS."
}

# Allow scripts to run so scoop can install
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

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

# Install core packages required for adding custom buckets
scoop install git

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
    git pull --ff-only
}

# Run global initialization script
$adminSetupPath = Resolve-Path -Path .\scripts\admin-setup.ps1
$adminSetupArgs = "-NoProfile -File `"$adminSetupPath`""
$adminProcess = Start-Process -FilePath pwsh.exe -ArgumentList $adminSetupArgs -Verb RunAs -Wait -PassThru

# Run dotfiles install script
.\scripts\install.ps1

Pop-Location
