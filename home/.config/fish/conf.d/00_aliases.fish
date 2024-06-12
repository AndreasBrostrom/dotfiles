
# ls
alias ls='ls --color=auto'
alias ll='ls -alF --group-directories-first'
alias lsl='ls -lF --group-directories-first'
alias la='ls -A'
alias lsa='la'
alias lsla='ls -la --group-directories-first'
alias lslA='ls -lA --group-directories-first'
alias l='ls -CF'
alias lr='ls -ltrh'
alias lra='ls -ltrha'
alias lsR='ls -R'
alias llR='ll -R'
alias laR='la -R'
alias dir='dir --color=auto'
alias dir='ls -l'
alias vdir='vdir --color=auto'

alias ccat='bat'

# cd with ls
function cdls
    cd $argv; ls
end
alias cdd='cdls'
function cdll
    cd $argv; ll
end
alias cdl='cdll'
alias lscd='cdls'
alias lcd='cdls'

# cd 
alias cdcd='cd'
alias cd..='cd ..'

# ip
alias arp='ip neighbor'
alias netstat='ss'
alias route='ip route'
alias ifconfig='ip addr'

# grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias clr='clear'
#alias cp='cp -i'
alias df='df -h'
alias free='free -m'

# Arch
alias lock='blurlock'
alias disable-lock='pkill -9 -f xautolock'
alias disable-autolock='disable-lock'

# gui sudo
alias gsudo='/usr/bin/pkexec'
