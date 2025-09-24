#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "$0")" || exit; pwd)
FILES=("${SCRIPT_DIR}/.*")
# shellcheck disable=SC2128

case $(uname) in
  Darwin)
    LN_OPTS="-sv"
    ;;
  Linux)
    LN_OPTS="-sv --backup=numbered"
    ;;
esac


for file in ${FILES}; do
  if [ -f "${file}" ]; then
    FILE_BASENAME=$(basename -- "${file}")
    ln ${LN_OPTS} "${file}" "${HOME}/${FILE_BASENAME}"
  fi
done
