 
# Upgrade
if [ -f "/etc/os-release" ] && [ "$(cat /etc/os-release | grep ID_LIKE | cut -f 2 -d '=')" == "ubuntu" ] || [ "$(cat /etc/os-release | grep ID_LIKE | cut -f 2 -d '=')" == "debian" ]; then
    alias upgrade='
        sudo -v
        echo -e "\033[1mUpgrading all system ...\033[0m"
        echo "Ubuntu (Debian)"
        echo -e "\033[32mapt\033[0m"
        sudo apt update
        sudo apt full-upgrade -y
        sudo apt autoremove -y
        echo -e "\033[32mflatpak\033[0m"
        flatpak update -y
        echo -e "\033[32msnap\033[0m"
        sudo snap refresh
        echo -e "\033[1mAll updates are completed.\033[0m"
    '
fi
if [ -f "/etc/os-release" ] && [ $("$(cat /etc/os-release | grep ID_LIKE | cut -f 2 -d '=')" == "arch") ]; then
    alias upgrade='
        sudo -v
        echo -e "\033[1mUpgrading all system...\033[0m"
        echo "Arch Linux"
        echo -e "\033[32mPacman\033[0m"
        sudo pacman -Syyu
        echo -e "\033[32mYay\033[0m"
        yay -Syyu
        notify-send "Pacman and Yay" "Upgrade completed" --urgency=low
        echo -e "\033[1mFull upgrade completed\033[0m"
    '
    alias upgrade-unattended='
        sudo -v
        echo -e "\033[1mUpgrading all system...\033[0m"
        echo "Arch Linux (Unattended)"
        echo -e "\033[32mPacman\033[0m"
        yes "" | sudo pacman -Syyu
        echo -e "\033[32mYay\033[0m"
        yes "" | yay -Syyu
        notify-send "Pacman and Yay" "Upgrade completed" --urgency=low
        echo -e "\033[1mFull upgrade completed\033[0m"
    '
fi
if [ -f "/etc/os-release" ] && [ "$(cat /etc/os-release | grep ID | cut -f 2 -d '=' | head -1)" == "alpine" ]; then
    alias upgrade='
        sudo -v
        echo -e "\033[1mUpgrading all system...\033[0m"
        sudo apk update
        sudo apk upgrade
        echo -e "\033[1mAll updates are completed.\033[0m"
    '
fi
if [ -d "/data/data/com.termux" ]; then
    alias upgrade='
        echo -e "\033[1mUpgrading all system...\033[0m"
        echo "Termux (Android)"
        echo -e "\033[32mapt\033[0m"
        apt update && apt full-upgrade -y
        apt autoremove -y
        echo -e "\033[32mpkg\033[0m"
        pkg upgrade -y
        echo -e "\033[1mAll updates are completed.\033[0m"
    '
fi

# Python
[[ "$(which pip3 1>/dev/null 2>&1; echo $?)" == "0"          ]] && alias pip='pip3'
[[ "$(which python3 1>/dev/null 2>&1; echo $?)" == "0"       ]] && alias py='python3'
[[ "$(which python3 1>/dev/null 2>&1; echo $?)" == "0"       ]] && alias python='python3'

# Programs
[[ "$(which nvim 1>/dev/null 2>&1; echo $?)" == "0"          ]] && alias vim='nvim'
[[ "$(which emulator 1>/dev/null 2>&1; echo $?)" == "0"      ]] && alias emulator='~/.bin/emulator_proxy'

# ADB
if [[ "$(which adb 1>/dev/null 2>&1; echo $?)" == "0" ]]; then
    alias adb-reverse='adb reverse tcp:8081 tcp:8081'
    alias adb-r='adb-reverse'
    [[ -f $(which adb-push 1>/dev/null 2>&1)  ]] && alias adb-p='adb-push'

    alias adb-reload='adb-ksey -r'
    alias adb-re='adb-reload'
    
    alias logcat='adb logcat'
fi

# Git
if [[ "$(which git 1>/dev/null 2>&1; echo $?)" == "0" ]]; then
    alias g-s='git status'
    alias g-c='git checkout'
    alias g-cm='git checkout master'
    alias g-cpr='git checkout-pr'
    alias g-b='git branch'
    alias g-f='git fetch --all --prune'
    alias g-r='git rebase'
    alias g-u='git rebase master'
    alias g-pu='git push'
    alias g-puf='git push fork'
    alias g-puff='git push --set-upstream fork $(git rev-parse --abbrev-ref HEAD)'
    alias g-fr='g-f; g-r'
    alias g-rf='g-fr'
    alias g-fu='g-f; g-u'
    alias g-uf='g-fu'

    alias g-p='git stash'
    alias g-pp='git stash pop'

    alias g-cp='g-p; g-c'
    alias g-cmp='g-p; g-cm'
    alias g-cmpp='g-p; g-cm; g-pp'
    alias g-frp='g-p; g-rf'
    alias g-rfp='g-frp'
    alias g-frpp='g-frp; g-pp'
    alias g-rfpp='g-rfpp'
    g-clean () {
        echo "Clearing merged/gone local branches..."
        git fetch -p
        for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do git branch -D $branch; done
        git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d 2&>/dev/null
        echo -e "Cleaning completed."
        if [[ $(git branch -vv | cut -c 3- | awk '$3 !~/\[/') ]]; then
            echo -e "\nFollowing branches have no remote:"
            git branch -vv | cut -c 3- | awk '$3 !~/\[/ { print " > "$1 }'
        fi
    }
fi

# Arch
if [ -f "/etc/os-release" ] && [ "$(cat /etc/os-release | grep ID_LIKE | cut -f 2 -d '=')" == "arch" ]; then
    alias ifconfig='ip addr'
fi

# Windows Linux SubSytstem
if grep -iq 'microsoft' /proc/version &> /dev/null; then
    alias explorer='explorer.exe'
    alias calc='calc.exe'
    
    alias terminator='detach terminator'
    alias nemo='detach nemo'
fi

# Android Termux Terminal
if [ -d "/data/data/com.termux" ]; then
    alias sudo='su'
    
    alias toast='termux-toast -g top'
    alias ring='termux-telephony-call'
    alias contacts='termux-contact-list | jq'
    alias vol='termux-volume'
    alias vib='termux-vibrate -f'
    alias clip='termux-clipboard-set'
fi

# POP
if [[ "$(which pop 1>/dev/null 2>&1; echo $?)" == "0" ]]; then
    popj () {
        pop pop://join?roomId=$1
    }
fi