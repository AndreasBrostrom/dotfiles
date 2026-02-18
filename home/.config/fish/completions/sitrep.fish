# Fish completions for sitrep
# Disable file completion
complete -c sitrep -f

# --upgrade / -u / --pull / -p
complete -c sitrep -s u -l upgrade -d 'Update repositories if no changes are found'
complete -c sitrep -s p -l pull    -d 'Update repositories if no changes are found'

# --commit / -c / --push / -pu
complete -c sitrep -s c -l commit -d 'Commit and push changes to repositories'
complete -c sitrep -l push         -d 'Commit and push changes to repositories'

# --install / -i
complete -c sitrep -s i -l install -d 'Run install script for dotfiles (when changes exist)'

# --force-install / -f / -fi / -if
complete -c sitrep -s f -l force-install -d 'Force run install script for dotfiles'

# --help / -h
complete -c sitrep -s h -l help -d 'Show help message'