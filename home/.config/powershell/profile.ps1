# Globlas
$ENV:USERNAME = $ENV:USER
$ENV:USERPROFILE = $(Get-Variable HOME -valueOnly)              # assume homefolder folder
$ENV:LOCALAPPDATA = "$(Get-Variable HOME -valueOnly)/.config"   # assume config folder


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
