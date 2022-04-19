
function upgrade
    sudo -v
    echo -e '\033[1mFully upgrading system and packages...\033[0m'
    echo -e '\033[32mPacman\033[0m'
    echo -e '\033[2mUpgrade is running as unattended\033[0m'
    sudo pacman -Syyu
    echo -e '\033[2mUpgrade is running as unattended\033[0m'
    yay -Syyu
    notify-send 'Pacman and Yay' '<i>System upgrade is complet.</i>' --urgency=normal
    sudo --reset-timestamp
    echo -e '\033[1mFull upgrade completed\033[0m'
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
alias gcm='git checkout master'
alias gcpr='git checkout-pr'
alias gb='git branch'
alias gf='git fetch --all --prune'
alias gr='git rebase'
alias grm='git rebase origin/main'
alias gpu='git push'
alias gpuf='git push fork'
alias gpuff='eval git push --set-upstream fork $(git rev-parse --abbrev-ref HEAD)'
alias gp='git stash'
alias gpp='git stash pop'

alias gfr='gf; gr'                                 # fetch rebase
alias gfm='gf; grm'                                # fetch rebase:orgin/master
alias gfrp='gp; gf; grm'                           # stash fetch rebase:orgin/master
alias gfrpp='gp; gf; grm; gpp'                     # stash fetch rebase:orgin/master pop
alias gcp='gp; gc'                                 # stash checkout

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

alias arp='ip neighbor'
alias netstat='ss'
alias route='ip route'
alias ifconfig='ip addr'

# Arch
alias lock='blurlock'
alias disable-lock='pkill -9 -f xautolock'
