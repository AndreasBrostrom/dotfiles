
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
alias cdd='cdls'
function cdll
    cd $argv; ll
end
alias cdl='cdll'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias clr='clear'
#alias cp='cp -i'
alias df='df -h'
alias free='free -m'


# Python
alias py='python'

# Programs
alias vim='nvim'

# ADB
alias adb-reverse='adb reverse tcp:8081 tcp:8081'
alias adb-r='adb-reverse'

alias adb-url='adb shell am start -a android.intent.action.VIEW -d '


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

# Git other
alias gccl='git ccl'
alias gccs='git ccs'

# GitHub-Cli
alias ghc='gcpr'
alias gpr='gh pr'
alias gprl='gpr list'
alias gprr='gpr review'
alias gprm='gpr merge'


# Arch
alias lock='blurlock'
alias disable-lock='pkill -9 -f xautolock'
alias disable-autolock='disable-lock'
