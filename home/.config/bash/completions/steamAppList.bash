# Bash completions for steamAppList
_steamAppList_completion() {
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="-p --path -d --disk -h --help"

    if [[ ${cur} == -* ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
    fi
}

complete -F _steamAppList_completion steamAppList
