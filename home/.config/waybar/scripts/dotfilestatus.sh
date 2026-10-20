#!/bin/bash
# Waybar custom module for dotfiles status monitoring
# Checks multiple git repositories and displays a warning when changes are detected.
# The tooltip lists the changed files per repo using Pango markup.

_symbol="!"
_max_files=12
_repos=(
    "dotfiles"
    "dotfiles_private"
    "Tools"
    "wdotfiles"
)

# Grimdark palette (see style.css)
_c_repo="#7aa6c4"
_c_dim="#8f8a80"
_c_mod="#bfa36a"
_c_add="#8aa57a"
_c_del="#b8625a"
_c_ren="#7aa6c4"

escape_markup() {
    local s="${1//&/&amp;}"
    s="${s//</&lt;}"
    echo "${s//>/&gt;}"
}

status_color() {
    case "$1" in
        *D*) echo "$_c_del" ;;
        *A*) echo "$_c_add" ;;
        *R*|*C*) echo "$_c_ren" ;;
        "??") echo "$_c_dim" ;;
        *) echo "$_c_mod" ;;
    esac
}

# Prints the tooltip section for one repo, nothing if it is clean or missing
repo_section() {
    local repo="$1"
    local path="$HOME/Repositories/$repo"
    [[ -d "$path" ]] || return

    local lines
    mapfile -t lines < <(git -C "$path" status --porcelain 2>/dev/null)
    [[ ${#lines[@]} -gt 0 ]] || return

    local count=${#lines[@]}
    local files="files"
    [[ $count -eq 1 ]] && files="file"
    printf '<span color="%s"><b>%s</b></span>  <span color="%s">%d %s</span>\n' \
        "$_c_repo" "$repo" "$_c_dim" "$count" "$files"

    local line code file letter
    for line in "${lines[@]:0:$_max_files}"; do
        code="${line:0:2}"
        file="$(escape_markup "${line:3}")"
        letter="${code// /}"
        printf '<tt><span color="%s">%s</span>  %s</tt>\n' "$(status_color "$code")" "${letter:0:1}" "$file"
    done
    if [[ $count -gt $_max_files ]]; then
        printf '<span color="%s">  + %d more</span>\n' "$_c_dim" $((count - _max_files))
    fi
}

while true; do
    tooltip=""
    for repo in "${_repos[@]}"; do
        section="$(repo_section "$repo")"
        [[ -n "$section" ]] && tooltip+="${tooltip:+$'\n\n'}$section"
    done

    # jq handles the JSON escaping (newlines, quotes) of the markup
    if [[ -n "$tooltip" ]]; then
        jq -cn --arg text "$_symbol" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip, class: "warning"}'
    else
        jq -cn '{text: "", tooltip: "All dotfiles clean", class: "clean"}'
    fi

    sleep 10
done
