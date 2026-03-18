
# ls
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

alias ccat='bat'

# grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# System
alias clr='clear'
alias more='less'
alias df='df -h'
alias free='free -m'
alias np='vim PKGBUILD'

# ip
alias arp='ip neighbor'
alias netstat='ss'
alias route='ip route'
alias ifconfig='ip addr'

# cd
alias ..='cd ..'

# gui sudo
alias gsudo='/usr/bin/pkexec'

# ex - archive extractor
# usage: ex <file>
ex () {
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
