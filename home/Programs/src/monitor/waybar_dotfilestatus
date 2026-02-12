#!/bin/bash
# Waybar custom module for dotfiles status monitoring
# Checks multiple git repositories and displays a warning when changes are detected

_symbol="!"
_repos=(
    "dotfiles"
    "dotfiles_private"
    "Tools"
    "wdotfiles"
)

check_repo_status() {
    local repo="$1"
    local path="$HOME/Repositories/$repo"

    if [[ ! -d "$path" ]]; then
        return 1
    fi

    # Check for uncommitted changes or untracked files
    if [[ ! $(git -C "$path" status 2>/dev/null | grep "nothing to commit") ]] || \
       [[ $(git -C "$path" status 2>/dev/null | grep "Untracked files") ]]; then
        return 0
    fi

    return 1
}

while true; do
    changed_repos=()

    for repo in "${_repos[@]}"; do
        if check_repo_status "$repo"; then
            changed_repos+=("$repo")
        fi
    done

    if [[ ${#changed_repos[@]} -gt 0 ]]; then
        # Changes detected - output warning JSON
        tooltip="Changes detected in:\n$(printf '%s\n' "${changed_repos[@]}")"
        echo "{\"text\": \"$_symbol\", \"tooltip\": \"$tooltip\", \"class\": \"warning\"}"
    else
        # No changes - output empty or OK status
        echo "{\"text\": \"\", \"tooltip\": \"All dotfiles clean\", \"class\": \"clean\"}"
    fi

    sleep 10
done
