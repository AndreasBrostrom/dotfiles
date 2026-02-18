# Bash completions for playipp
_playipp_completion() {
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    local subcmds="devices devicedb id getid data adb.dat cbd.dat log refresh clear server-cache todo -h --help"

    # First argument: top-level subcommands
    if [[ ${COMP_CWORD} -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "${subcmds}" -- "${cur}") )
        return
    fi

    local subcmd="${COMP_WORDS[1]}"

    case "$subcmd" in
        devices|devicedb)
            local db_cmds="list connect refresh log scrcpy edit versions -h --help"
            if [[ ${COMP_CWORD} -eq 2 ]]; then
                COMPREPLY=( $(compgen -W "${db_cmds}" -- "${cur}") )
            else
                local db_subcmd="${COMP_WORDS[2]}"
                case "$db_subcmd" in
                    connect)
                        COMPREPLY=( $(compgen -W "-r --reconnect -h --help" -- "${cur}") )
                        ;;
                    refresh)
                        COMPREPLY=( $(compgen -W "-r -c -h --help" -- "${cur}") )
                        ;;
                    scrcpy)
                        COMPREPLY=( $(compgen -W "-k -h --help" -- "${cur}") )
                        ;;
                esac
            fi
            ;;
        server-cache)
            if [[ "$prev" == "--env" ]]; then
                COMPREPLY=( $(compgen -W "dev prod" -- "${cur}") )
            else
                COMPREPLY=( $(compgen -W "--env --clear -h --help" -- "${cur}") )
            fi
            ;;
    esac
}

complete -F _playipp_completion playipp
