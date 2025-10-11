function _cdd_base() {
  local base_dir=$1
  _path_files -W "$base_dir" -/
}

function _cdd() { _cdd_base "$DEVEL_PATH" }
function _cddc() { _cdd_base ~/Documents }
function _cddw() { _cdd_base ~/Downloads }
function _cdpc() { _cdd_base ~/Pictures }

compdef _cdd cdd
compdef _cddc cddc
compdef _cddw cddw
compdef _cdpc cdpc
