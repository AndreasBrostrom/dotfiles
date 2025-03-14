alias gs='git status'

alias gc='git checkout'
alias gcm="git checkout (git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')"

alias gcpr='git checkout-pr'

alias gb='git branch'

alias gf='git fetch --all --prune'

alias gr='git rebase'
alias grm='git rebase origin/main'

alias gpull='git pull'

alias gpush='git push'
alias gpu='gpush'
alias gpuf='git push fork'
alias gpuff='eval git push --set-upstream fork (git rev-parse --abbrev-ref HEAD)'

alias gp='git stash'
alias gpp='git stash pop'

# functions
alias gfr='gf; gr'                        # fetch rebase
alias gfm='gf; grm'                       # fetch rebase:orgin/master
alias gfrp='gp; gf; grm'                  # stash fetch rebase:orgin/master
alias gfrpp='gp; gf; grm; gpp'            # stash fetch rebase:orgin/master pop
alias gcp='gp; gc'                        # stash checkout
alias gpullp='gp; gpull'                  # stash pull
alias gpullpp='gp; gpull; gpp'            # stash pull pop

function gcpp                             # stash checkout pop
    eval gp; eval gc $argv; eval gpp ;
end
alias gcmp='gp; gcm'                      # stash checkout:master
alias gcmpp='gp; gcm; gpp'                # stash checkout:master pop
function gcprfr                           # fetch checkout:PR rebase
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
