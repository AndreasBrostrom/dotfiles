# Globlas
$Env:USERNAME = $Env:USER
$Env:USERPROFILE = $(Get-Variable HOME -valueOnly)              # assume homefolder folder
$Env:LOCALAPPDATA = "$(Get-Variable HOME -valueOnly)/.config"   # assume config folder


# RC if one exist
if (Test-Path "$Env:USERPROFILE/.pwshrc.ps1" -PathType leaf) {
    . "$Env:USERPROFILE/.pwshrc.ps1"
}
if (Test-Path "$Env:LOCALAPPDATA/powershell/rc.ps1" -PathType leaf) {
    . "$Env:LOCALAPPDATA/powershell/rc.ps1"
}
if (Test-Path "$Env:LOCALAPPDATA/powershell/aliases.ps1" -PathType leaf) {
    . "$Env:LOCALAPPDATA/powershell/aliases.ps1"
}
