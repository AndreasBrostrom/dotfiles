# Globlas
$Env:USERNAME = $Env:USER
$Env:USERPROFILE = $(Get-Variable HOME -valueOnly)              # assume homefolder folder
$Env:LOCALAPPDATA = "$(Get-Variable HOME -valueOnly)/.config"   # assume config folder

if (Test-Path "$Env:LOCALAPPDATA/powershell/config.ps1" -PathType leaf) {
    . "$Env:USERPROFILE/.config/powershell/config.ps1"
}
