# Bash completions for sitrep
_sitrep_completion() {
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="--upgrade -u --pull -p --commit -c --push -pu --install -i --force-install -f -fi -if --help -h"

    if [[ ${cur} == -* ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
    fi
}

complete -F _sitrep_completion sitrep
