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
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local base_dir=${HOME}/devel/
  local dir_names=$(_get_dir_names "$base_dir")
  COMPREPLY=($(compgen -W "${dir_names}" -- "${cur}"))
}

function _cddc() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local dir_names="$(_get_dir_names ${HOME}/Documents/)"
  echo $dir_names
  COMPREPLY=($(compgen -W "${dir_names}" -- "${cur}"))
}

complete -F _cdd cdd
complete -F _cddc cddc
