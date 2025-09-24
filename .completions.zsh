function _get_dir_names() {
  local base_dir="$1"
  local IFS=$'\n'
  local dir_names=()
  for d in "${base_dir}"*/; do
    d="${d%/}" # Remove the trailing slash
    dir_names+=("${d##*/}") # Extract the directory name using built-in string manipulation
  done
  printf "%s\n" "${dir_names[@]}"
}

function _cdd() {
  local -a files
  IFS=$'\n' read -rd '' -A files <<< "$(_get_dir_names ${HOME}/devel/)"
  _describe 'file' files
}

function _cddc() {
  local -a files
  IFS=$'\n' read -rd '' -A files <<< "$(_get_dir_names ${HOME}/Documents/)"
  _describe 'file' files
}

function _cddw() {
  local -a files
  IFS=$'\n' read -rd '' -A files <<< "$(_get_dir_names ${HOME}/Downloads/)"
  _describe 'file' files
}

function _cdpc() {
  local -a files
  IFS=$'\n' read -rd '' -A files <<< "$(_get_dir_names ${HOME}/Pictures/)"
  _describe 'file' files
}

compdef _cdd cdd
compdef _cddc cddc
compdef _cddw cddw
compdef _cdpc cdpc
