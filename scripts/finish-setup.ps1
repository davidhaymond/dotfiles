$debianPath = scoop which debian.exe
if (!$debianPath) {
    $appxPath = New-TemporaryFile
    Invoke-RestMethod -Uri https://aka.ms/wsl-debian-gnulinux -OutFile $appxPath
    Add-AppxPackage -Path $appxPath
    $appxPath | Remove-Item -Force
}
debian.exe install
debian.exe run "sudo apt-get update -y; sudo apt-get install curl -y; curl -sSL https://setup.davidhaymond.dev/linux | bash"
