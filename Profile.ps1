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
    ~\.dotfiles\scripts\install.ps1
}

function check-dotfiles {
    Push-Location ~\.dotfiles | Out-Null
        if (git status --porcelain) {
            Write-Information "The dotfiles repo has uncommitted changes:" -InformationAction Continue
                git status --short
        }
    Pop-Location | Out-Null
}
check-dotfiles

function new-key {
    $sshDir = Join-Path -Path (Resolve-Path ~) -ChildPath .ssh
    if (!(Test-Path $sshDir)) {
        New-Item -Path $sshDir -ItemType Directory -Force | Out-Null
    }
    $keyPath = Join-Path -Path $sshDir -ChildPath id_ed25519
    ssh-keygen -t ed25519 -a 512 -f "$keyPath"
    Write-Output "`e[36;1mPublic key:`e[0m"
    Get-Content -Path "$keyPath.pub"
}

function load-keys {
    ssh-agent
    ssh-add
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

New-Alias -Name 'reboot' -Value Restart-Computer -Option ReadOnly
New-Alias -Name 'shutdown' -Value Stop-Computer -Option ReadOnly
New-Alias -Name 'ms' -Value Measure-Object -Option ReadOnly
