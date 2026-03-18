
gitshort() {                                  # git help sort commands
    echo "Git Aliases Help:"
    echo ""
    echo "General:"
    echo "  g         -> git"
    echo "  gi        -> git init"
    echo "  gcl       -> git clone"
    echo ""
    echo "Status and Branching:"
    echo "  gs        -> git status"
    echo "  gb        -> git branch"
    echo ""
    echo "Checkout:"
    echo "  gC        -> git checkout"
    echo "  gCm       -> git checkout (default branch)"
    echo "  gCpr      -> git checkout-pr"
    echo ""
    echo "Add and Commit:"
    echo "  ga        -> git add"
    echo "  gc        -> git commit"
    echo ""
    echo "Fetch and Rebase:"
    echo "  gf        -> git fetch --all --prune"
    echo "  gr        -> git rebase"
    echo "  grm       -> git rebase origin/main"
    echo ""
    echo "Pull and Push:"
    echo "  gp        -> git pull"
    echo "  gpo       -> git pull origin"
    echo "  gpu       -> git push"
    echo "  gpuo      -> git push origin"
    echo "  gpuof     -> git push --set-upstream origin (current branch)"
    echo "  gpuf      -> git push fork"
    echo "  gpuff     -> git push --set-upstream fork (current branch)"
    echo ""
    echo "Stash:"
    echo "  gS        -> git stash"
    echo "  gSP       -> git stash pop"
    echo ""
    echo "Combined Commands:"
    echo "  gfr       -> gf; gr (fetch and rebase)"
    echo "  gfm       -> gf; grm (fetch and rebase origin/main)"
    echo "  gfrS      -> gS; gf; grm (stash, fetch, rebase origin/main)"
    echo "  gfrSP     -> gS; gf; grm; gSP (stash, fetch, rebase origin/main, pop)"
    echo "  gcp       -> gS; gc (stash and commit)"
    echo "  gpS       -> gS; gp (stash and pull)"
    echo "  gpSP      -> gS; gp; gSP (stash, pull, pop)"
    echo "  gcpp      -> gS; gC <args>; gSP (stash, checkout, pop)"
    echo "  gcmS      -> gS; gCm (stash and checkout master)"
    echo "  gcmSP     -> gS; gCm; gSP (stash, checkout master, pop)"
    echo "  gcprfr    -> gf; gcpr <args>; gr (fetch, checkout PR, rebase)"
    echo ""
    echo "GitHub CLI:"
    echo "  ghc       -> gCpr"
    echo "  gpr       -> gh pr"
    echo "  gprl      -> gpr list"
    echo "  gprr      -> gpr review"
    echo "  gprm      -> gpr merge"
    echo ""
    echo "Other:"
    echo "  gccl      -> git ccl"
    echo "  gccs      -> git ccs"
}
alias gshort='gitshort'

# Git Aliases
alias g='git'
alias gi='git init'
alias gcl='git clone'

alias gs='git status'

alias gC='git checkout'
gCm() { git checkout $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'); }
alias gCpr='git checkout-pr'

alias gb='git branch'

alias ga='git add'

alias gc='git commit'

alias gf='git fetch --all --prune'

alias gr='git rebase'
alias grm='git rebase origin/main'

alias gp='git pull'
alias gpo='git pull origin'

alias gpu='git push'
alias gpuo='git push origin'
gpuof() { git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD); }
alias gpuf='git push fork'
gpuff() { git push --set-upstream fork $(git rev-parse --abbrev-ref HEAD); }

alias gS='git stash'
alias gSP='git stash pop'

# Combined
alias gfr='gf; gr'                          # fetch rebase
alias gfm='gf; grm'                         # fetch rebase:origin/main
alias gfrS='gS; gf; grm'                    # stash fetch rebase:origin/main
alias gfrSP='gS; gf; grm; gSP'             # stash fetch rebase:origin/main pop
alias gcp='gS; gc'                          # stash commit

alias gpS='gS; gp'                          # stash pull
alias gpSP='gS; gp; gSP'                   # stash pull pop

gcpp() { gS; gC "$1"; gSP; }               # stash checkout pop
alias gcmS='gS; gCm'                        # stash checkout:main
alias gcmSP='gS; gCm; gSP'                 # stash checkout:main pop
gcprfr() { gf; gCpr "$1"; gr; }            # fetch checkout:PR rebase

# Git other
alias gccl='git ccl'
alias gccs='git ccs'

# GitHub-Cli
alias ghc='gCpr'
alias gpr='gh pr'
alias gprl='gpr list'
alias gprr='gpr review'
alias gprm='gpr merge'
