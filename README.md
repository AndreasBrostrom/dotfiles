# dotfiles

```bash
./install
```

## Setup new

#### Termux Android
```bash
bash <(curl -s https://raw.githubusercontent.com/AndreasBrostrom/Tools/master/SetupScripts/setupAndroidTermux.sh)
```
#### Arch i3
```bash
bash <(curl -s https://raw.githubusercontent.com/AndreasBrostrom/Tools/master/SetupScripts/setupArchI3.sh)
```

#### Configs
```bash
sudo cp etc/lightdm/lightdm-webkit2-greeter.conf       /etc/lightdm/lightdm-webkit2-greeter.conf
sudo cp etc/lightdm/lightdm.conf                       /etc/lightdm/lightdm.conf
sudo cp etc/modprobe.d                                 /etc/modprobe.d
sudo cp etc/modprobe.d/nobeep.conf                     /etc/modprobe.d/nobeep.conf
sudo cp etc/samba/smb.conf                             /etc/samba/smb.conf

sudo cp etc/X11/xorg.conf.d                            /etc/X11/xorg.conf.d

sudo cp etc/X11/xorg.conf.d/00-keyboard.conf           /etc/X11/xorg.conf.d/00-keyboard.conf
sudo cp etc/X11/xorg.conf.d/30-touchpad-libinput.conf  /etc/X11/xorg.conf.d/30-touchpad.conf
sudo cp etc/X11/xorg.conf.d/30-touchpad-synaptic.conf  /etc/X11/xorg.conf.d/30-touchpad.conf

sudo cp etc/X11/xorg.conf.d/91-monitor-home.conf       /etc/X11/xorg.conf.d/91-monitor-home.conf
sudo cp etc/X11/xorg.conf.d/91-monitor-office.conf     /etc/X11/xorg.conf.d/91-monitor-office.conf
sudo cp etc/X11/xorg.conf.d/92-xpra-virtual.conf       /etc/X11/xorg.conf.d/92-xpra-virtual.conf

```

## Themes

The dark look in the GTK settings, `.gtkrc-2.0`, niri and the LightDM greeter needs these themes:

| Theme | Used as | Arch package |
|---|---|---|
| Breeze-Dark | GTK theme (GTK 2/3/4, greeter, niri) | `breeze-gtk` |
| Black-BigSur-dark | Icon theme (GTK, niri) | none, put it in `~/.icons/Black-BigSur-dark` by hand |
| Papirus-Dark | Icon theme (LightDM greeter) | `papirus-icon-theme` |
| Adwaita | Cursor theme, size 28 | `adwaita-cursors` |
| ocean | Sound theme | `ocean-sound-theme` |
| Noto Sans | UI font | `noto-fonts` |

```bash
paru -S breeze-gtk papirus-icon-theme adwaita-cursors ocean-sound-theme noto-fonts \
        qt5ct qt6ct numix-circle-icon-theme-git
```

`qt5ct`, `qt6ct` and `numix-circle-icon-theme-git` (AUR) are for Qt apps under niri.
