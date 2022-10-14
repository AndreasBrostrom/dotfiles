
alias ls='ls --color=auto'
alias ll='ls -alF'
alias lsl='ls -lF'
alias la='ls -A'
alias lsa='la'
alias l='ls -CF'
alias lr='ls -ltrh'
alias lra='ls -ltrha'
alias lsR='ls -R'
alias llR='ll -R'
alias laR='la -R'
alias dir='dir --color=auto'
alias dir='ls -l'
alias vdir='vdir --color=auto'

alias arp='ip neighbor'
alias netstat='ss'
alias route='ip route'
alias ifconfig='ip addr'

function cdls
    cd $argv; ls
end

function cdll
    cd $argv; ll
end

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias clr='clear'
alias cp='cp -i'
alias df='df -h'
alias free='free -m'

# Upgrade function
function upgrade
    if exist pacman # Arch
        if exist yay
            sudo -v
            echo -e '\033[1mFully upgrading system and packages...\033[0m'
            echo -e '\033[1;32myay\033[0m'
            yay -Syyu --sudoloop --noconfirm --color=always
            exist flatpak && echo -e "\033[32mflatpak\033[0m"
            exist flatpak && flatpak update -y
            exist snap && echo -e "\033[32msnap\033[0m"
            exist snap && sudo snap refresh
            notify-send 'yay' '<i>System upgrade is complet.</i>' --urgency=normal
            sudo --reset-timestamp
            echo -e '\033[1mFull upgrade completed\033[0m'
            return
        end
        sudo -v
        echo -e '\033[1mFully upgrading system and packages...\033[0m'
        echo -e '\033[1;32myay\033[0m'
        sudo pacman -Syyu --noconfirm --color=always
        exist flatpak && echo -e "\033[32mflatpak\033[0m"
        exist flatpak && flatpak update -y
        exist snap && echo -e "\033[32msnap\033[0m"
        exist snap && sudo snap refresh
        notify-send 'pacman' '<i>System upgrade is complet.</i>' --urgency=normal
        sudo --reset-timestamp
        echo -e '\033[1mFull upgrade completed\033[0m'
        return
    end
    if exist apt # Ubuntu
        if exist pkg # Termux wrapper
            echo -e '\033[1mFully upgrading system and packages...\033[0m'
            echo -e '\033[1;32mpkg\033[0m'
            pkg upgrade -y
            pkg autoclean
            exist termux-notification && termux-notification -i "tuUpdatePKG" -t "Termux PKG" -c "System upgrade is complet." --led-color AAFF00
            echo -e '\033[1mFull upgrade completed\033[0m'
            return
        end
        sudo -v
        echo -e '\033[1mFully upgrading system and packages...\033[0m'
        echo -e "\033[32mapt\033[0m"
        sudo apt update
        sudo apt full-upgrade -y
        sudo apt autoremove -y
        exist flatpak && echo -e "\033[32mflatpak\033[0m"
        exist flatpak && flatpak update -y
        exist snap && echo -e "\033[32msnap\033[0m"
        exist snap && sudo snap refresh
        notify-send 'apt' '<i>System upgrade is complet.</i>' --urgency=normal
        echo -e "\033[1mAll updates are completed.\033[0m"
        return
    end
end

# Python
alias pip='pip3'
alias py='python3'
alias python='python3'

# Programs
alias vim='nvim'
alias emulator='~/.bin/emulator_proxy'

# ADB
alias adb-reverse='adb reverse tcp:8081 tcp:8081'
alias adb-r='adb-reverse'

alias adb-p='adb-push'

alias adb-reload='adb-key -r'
alias adb-re='adb-reload'
    
alias logcat='adb logcat'

# git
alias gs='git status'
alias gc='git checkout'
alias gcm="git checkout (git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')"
alias gcpr='git checkout-pr'
alias gb='git branch'
alias gf='git fetch --all --prune'
alias gr='git rebase'
alias grm='git rebase origin/main'
alias gpull='git pull'
alias gpu='git push'
alias gpuf='git push fork'
alias gpuff='eval git push --set-upstream fork (git rev-parse --abbrev-ref HEAD)'
alias gp='git stash'
alias gpp='git stash pop'

alias gfr='gf; gr'                                 # fetch rebase
alias gfm='gf; grm'                                # fetch rebase:orgin/master
alias gfrp='gp; gf; grm'                           # stash fetch rebase:orgin/master
alias gfrpp='gp; gf; grm; gpp'                     # stash fetch rebase:orgin/master pop
alias gcp='gp; gc'                                 # stash checkout
alias gpullp='gp; gpull'                           # stash pull
alias gpullpp='gp; gpull; gpp'                     # stash pull pop

function gcpp                                      # stash checkout pop
    eval gp; eval gc $argv; eval gpp ;
end
alias gcmp='gp; gcm'                               # stash checkout:master
alias gcmpp='gp; gcm; gpp'                         # stash checkout:master pop
function gcprfr                                    # fetch checkout:PR rebase
    eval gf; eval gcpr $argv; eval gr ;
end

# GitHub-Cli
alias ghc='gcpr'
alias ghr='gh pr review'
alias ghm='gh pr merge'

# Arch
alias lock='blurlock'
alias disable-lock='pkill -9 -f xautolock'
alias disable-autolock='disable-lock'


