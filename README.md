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
sudo cp etc/X11/xorg.conf.d/30-touchpad.conf           /etc/X11/xorg.conf.d/30-touchpad.conf
sudo cp etc/X11/xorg.conf.d/91-monitor-office.conf     /etc/X11/xorg.conf.d/91-monitor-office.conf
sudo cp etc/X11/xorg.conf.d/92-xpra-virtual.conf       /etc/X11/xorg.conf.d/92-xpra-virtual.conf

```
