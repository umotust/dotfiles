# General directory completion under a base path
function _dir_complete_base() {
    local cur base
    _init_completion || return

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
