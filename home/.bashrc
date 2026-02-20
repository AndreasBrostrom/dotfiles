# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s expand_aliases

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000000
HISTFILESIZE=20000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Path Variables
if [ -f ~/.bash_path ]; then
  . ~/.bash_path
fi

# Theme Variables
if [ -f ~/.config/bash/theme ]; then
  . ~/.config/bash/theme
fi

# set object colors for ls
eval "$(dircolors ~/.config/dir_colors)"

# Windows Linux SubSytstem Terminal WSL
if grep -iq 'microsoft' /proc/version &> /dev/null; then
    #export DISPLAY=:0
    #export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0;
    #export LIBGL_ALWAYS_INDIRECT=1;
  if [[ "$PWD" = "/mnt/c/Windows/system32" || "$PWD" = "/mnt/c/WINDOWS/system32" ]]; then
    cd ~
  fi
fi

# ls Aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias lsl='ls -lF'
alias la='ls -A'
alias lsa='la'
alias l='ls -CF'
alias lr='ls -ltrh'
alias lra='ls -ltrha'
alias lra='ls -ltrha'
alias lsR='ls -R'
alias llR='ll -R'
alias laR='la -R'
alias dir='dir --color=auto'
alias dir='ls -l'
alias vdir='vdir --color=auto'

# grep Aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ccat='bat'

# System alias
alias clr='clear'
alias more=less
#alias cp="cp -i"
alias df='df -h'
alias free='free -m'
alias np='vim PKGBUILD'


alias ..='cd ..'

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
      *)           echo "'$1' cannot be extracted vixa ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Bash Aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Office specific
if [ -f ~/.bash_office ]; then
  . ~/.bash_office
fi

# Completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Custom completions
if [ -d ~/.config/bash/completions ]; then
  for f in ~/.config/bash/completions/*.bash; do
    [ -f "$f" ] && . "$f"
  done
fi

if [ -z "$SSH_AGENT_PID" ]; then
  eval `ssh-agent -s` >/dev/null 2>/dev/null 
fi

eval "$(starship init bash)"
