filter ConvertTo-Base64String {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string] $InputString
    )

    [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($InputString))
}

filter ConvertFrom-Base64String {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string] $InputString
    )

    [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($InputString))
}

function update-dotfiles {
    Push-Location -Path ~\.dotfiles
    & .\install.ps1
    Pop-Location
}

function new-key {
    $keyPath = Resolve-Path -Path ~\.ssh\id_ed25519
    ssh-keygen -t ed25519 -a 64 -C haymondtechnologies@gmail.com -f "$keyPath"
    Write-Output "%b\n" "\e[36;1mPublic key:\e[0m"
    Get-Content -Path "$keyPath.pub"
}

function clone {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [string] $Repo
    )

    git clone git@github.com:$Repo.git
}
