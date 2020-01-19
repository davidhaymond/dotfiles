if ($IsLinux) {
    throw "This script supports Windows only. To install dotfiles on Linux, run `"curl https://setup.davidhaymond.dev | bash`"."
}
elseif ($IsMacOS) {
    throw "This script supports Windows only. This dotfiles repo is not yet supported on macOS."
}

# Install scoop if needed
$isScoopInstalled = Test-Path -Path ~\scoop -PathType Container
if ($isScoopInstalled) {
    scoop update
    scoop update *
}
else {
    Invoke-RestMethod -Uri get.scoop.sh | Invoke-Expression
}

# Install core packages required for adding custom buckets
scoop install 7zip git

# Add buckets
scoop bucket add extras
scoop bucket add david https://github.com/davidhaymond/scoop-bucket.git

# Install additional packages
scoop install gpmdp hyper keepass-pps lmir-tech-console nodejs telegram vim vimtutor vscode

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
}

# Run global initialization script
$initScriptPath = Resolve-Path -Path .\intialize-windows.ps1
$args = "-NoProfile -ExecutionPolicy Bypass -File `"$initPath`""
Start-Process -FilePath powershell.exe -ArgumentList $args -Verb RunAs -Wait

.\install.ps1
Pop-Location
