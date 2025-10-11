function _cdd() {
  _path_files -W "$DEVEL_PATH" -/
}

function _cddc() {
  _path_files -W "$HOME/Documents" -/
}

function _cddw() {
  _path_files -W "$HOME/Downloads" -/
}

function _cdpc() {
  _path_files -W "$HOME/Pictures" -/
}

compdef _cdd cdd
compdef _cddc cddc
compdef _cddw cddw
compdef _cdpc cdpc
