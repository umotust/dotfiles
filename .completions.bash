# General directory completion under a base path
function _dir_complete_base() {
    local cur base

    # Only use _init_completion if available
    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion || return
    else
        # Fallback if bash-completion is not installed
        cur="${COMP_WORDS[COMP_CWORD]}"
    fi

    local IFS=$'\n'
    compopt -o filenames

    # base path is passed as first argument
    base="$1"

    # Generate directory completion
    local -a dirs
    dirs=($(compgen -d -- "$base/$cur"))

    # Strip base prefix for cleaner display
    COMPREPLY=()
    for dir in "${dirs[@]}"; do
        COMPREPLY+=("${dir#$base/}")
    done
}

function _cdd() {
    _dir_complete_base "$DEVEL_PATH"
}

function _cddc() {
    _dir_complete_base "$HOME/Documents"
}

function _cddw() {
    _dir_complete_base "$HOME/Downloads"
}

function _cdpc() {
    _dir_complete_base "$HOME/Pictures"
}

complete -F _cdd -o nospace cdd
complete -F _cddc -o nospace cddc
complete -F _cddw -o nospace cddw
complete -F _cdpc -o nospace cdpc
