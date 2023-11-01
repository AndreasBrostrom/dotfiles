# dotfiles

```bash
./install
```

## Setup new

#### Termux Android
```bash
bash <(curl -s https://raw.githubusercontent.com/AndreasBrostrom/Tools/master/SetupScripts/setupAndroidTermux.sh)
```

#### Manjaro i3
```bash
bash <(curl -s https://raw.githubusercontent.com/AndreasBrostrom/Tools/master/SetupScripts/setupManjaroI3.sh)
```

```bash
sudo cp etc/X11/xorg.conf.d/00-keyboard.conf /etc/X11/xorg.conf.d/.
sudo cp etc/X11/xorg.conf.d/30-touchpad.conf /etc/X11/xorg.conf.d/.
sudo cp etc/X11/xorg.conf.d/91-monitor-office.conf /etc/X11/xorg.conf.d/.
sudo cp etc/X11/xorg.conf.d/92-xpra-virtual.conf /etc/X11/xorg.conf.d/.
```
