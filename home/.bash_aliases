 
# Upgrade
if [ -f "/etc/os-release" ] && [ "$(cat /etc/os-release | grep ID_LIKE | cut -f 2 -d '=')" == "ubuntu" ] || [ -f "/etc/os-release" ] && [ "$(cat /etc/os-release | grep ID_LIKE | cut -f 2 -d '=')" == "debian" ]; then
    alias upgrade='
        sudo -v
        echo -e "\033[1mUpgrading all system ...\033[0m"
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
if [ -f "/etc/os-release" ] && [ "$(cat /etc/os-release | grep ID_LIKE | cut -f 2 -d '=')" == "arch" ]; then
    upgrade () {
        sudo -v
        if [[ $? == 1 ]] || [[ $(sudo -n uptime 2>&1 | grep "load" | grep -v "Sorry" | wc -l) != 1 ]]; then
            echo -e "\033[31mYou are not running as root\033[0m"
            return
        fi
        echo -e "\033[1mFully upgrading system and packages...\033[0m"
        if [[ "$1" == "-u" ]] || [[ "$1" == "--unattended" ]]; then
            echo -e "\033[2mUpgrade is running as unattended\033[0m"
        fi
        echo -e "\033[32mPacman\033[0m"
        if [[ "$1" == "-u" ]] || [[ "$1" == "--unattended" ]]; then
            yes ""| sudo pacman -Syyu
        else
            sudo pacman -Syyu
        fi
        if [[ $(sudo -n uptime 2>&1 | grep "load" | grep -v "Sorry" | wc -l) != 1 ]]; then
            echo -e "\033[33mYou have lost your root access...\033[0m"
            sudo -v
            [[ $? == 1 ]] && echo -e "\033[31mSomethign went wrong here\033[0m" && return
        fi
        echo -e "\033[32mYay\033[0m"
        if [[ "$1" == "-u" ]] || [[ "$1" == "--unattended" ]]; then
            echo -e "\033[2mUpgrade is running as unattended\033[0m"
        fi
        if [[ "$1" == "-y" ]]; then
            yes "" | yay -Syyu
        else
            yay -Syyu
        fi
        notify-send "Pacman and Yay" "Upgrade completed" --urgency=low
        sudo --reset-timestamp
        echo -e "\033[1mFull upgrade completed\033[0m"
    }
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
        pkg upgrade -y
	    pkg autoclean
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

    [[ -f $(which adb-key 1>/dev/null 2>&1)   ]] && alias adb-reload='adb-key -r'
    [[ -f $(which adb-key 1>/dev/null 2>&1)   ]] && alias adb-re='adb-reload'
    
    alias logcat='adb logcat'
fi

# Git
if [[ "$(which git 1>/dev/null 2>&1; echo $?)" == "0" ]]; then
    alias gs='git status'
    alias gc='git checkout'
    alias gcm='git checkout master'
    alias gcpr='git checkout-pr'
    alias gb='git branch'
    alias gf='git fetch --all --prune'
    alias gr='git rebase'
    alias grm='git rebase origin/master'
    alias gpu='git push'
    alias gpuf='git push fork'
    alias gpuff='git push --set-upstream fork $(git rev-parse --abbrev-ref HEAD)'
    alias gp='git stash'
    alias gpp='git stash pop'

    alias gfr='gf; gr'                                 # fetch rebase
    alias gfm='gf; grm'                                # fetch rebase:orgin/master
    alias gfrp='gp; gf; grm'                           # stash fetch rebase:orgin/master
    alias gfrpp='gp; gf; grm; gpp'                     # stash fetch rebase:orgin/master pop
    alias gcp='gp; gc'                                 # stash checkout
    gcpp () { eval gp; eval gc $1; eval gpp ; }        # stash checkout pop
    alias gcmp='gp; gcm'                               # stash checkout:master
    alias gcmpp='gp; gcm; gpp'                         # stash checkout:master pop
    gcprfr () { eval gf; eval gcpr $1; eval gr ; }     # fetch checkout:PR rebase
    gclean () {
        echo "Clearing merged/gone local branches..."
        git fetch --prune
        for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do git branch -D $branch; done
        git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d 2&>/dev/null
        echo -e "Cleaning completed."
        if [[ $(git branch -vv | cut -c 3- | awk '$3 !~/\[/') ]]; then
            echo -e "\nFollowing branches have no remote:"
            git branch -vv | cut -c 3- | awk '$3 !~/\[/ { print " > "$1 }'
        fi
    }

    # GitHub-Cli
    alias ghc='gcpr'
    alias ghr='gh pr review'
    alias ghm='gh pr merge'

fi

# Arch
if [ -f "/etc/os-release" ] && [ "$(cat /etc/os-release | grep ID_LIKE | cut -f 2 -d '=')" == "arch" ]; then
    alias arp='echo "$ ip neighbor"; ip neighbor'
    alias netstat='echo "$ ss"; ss'
    alias route='echo "$ ip route"; ip route'
    alias ifconfig='echo "$ ip addr"; ip addr'
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
    alias sms='termux-sms-send'
fi

# POP
if [[ "$(which pop 1>/dev/null 2>&1; echo $?)" == "0" ]]; then
    popj () {
        pop pop://join?roomId=$1
    }
fi
