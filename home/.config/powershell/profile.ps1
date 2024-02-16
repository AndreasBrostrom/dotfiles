# Globlas
$ENV:USERPROFILE = "$HOME"
$ENV:LOCALAPPDATA = "$ENV:USERPROFILE/.config"

# RC if one exist
if (Test-Path "$ENV:USERPROFILE/.pwshrc.ps1" -PathType leaf) {
    . "$ENV:USERPROFILE/.pwshrc.ps1"
}
if (Test-Path "$ENV:LOCALAPPDATA/powershell/rc.ps1" -PathType leaf) {
    . "$ENV:LOCALAPPDATA/powershell/rc.ps1"
}
if (Test-Path "$ENV:LOCALAPPDATA/powershell/aliases.ps1" -PathType leaf) {
    . "$ENV:LOCALAPPDATA/powershell/aliases.ps1"
}

$ENV:STARSHIP_CONFIG = "$ENV:LOCALAPPDATA/starship_pwsh.toml"
Invoke-Expression (&starship init powershell)
