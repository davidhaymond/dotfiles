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
