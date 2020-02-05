#Requires -Version 6.0

wsl.exe --set-default-version 2

$debianPath = &{scoop which debian.exe} 6> $null
if (!$debianPath) {
    $appxPath = New-TemporaryFile
    Invoke-RestMethod -Uri https://aka.ms/wsl-debian-gnulinux -OutFile $appxPath
    Add-AppxPackage -Path $appxPath
    $appxPath | Remove-Item -Force
}
debian.exe install
debian.exe run "sudo apt-get update -y; sudo apt-get install curl -y; curl -sSL https://dotfiles.davidhaymond.dev/linux | bash"
