#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "$0")" || exit; pwd)
FILES=("${SCRIPT_DIR}/".*)
# shellcheck disable=SC2128

case $(uname) in
  Darwin)
    LN_OPTS="-sv"
    ;;
  Linux)
    LN_OPTS="-sv --backup=numbered"
    ;;
esac

# Excluded files (exact names or patterns)
EXCLUDES=(
  ".DS_Store"
  ".pre-commit-config.yaml"
  ".secrets.baseline"
  "*.swp"
)

for file in "${FILES[@]}"; do
  FILE_BASENAME=$(basename -- "$file")

  # Skip non-regular files
  [ ! -f "$file" ] && continue

  # Skip excluded files
  skip=false
  for pattern in "${EXCLUDES[@]}"; do
    if [[ "$FILE_BASENAME" == $pattern ]]; then
      echo "skip: (excluded) ${FILE_BASENAME}"
      skip=true
      break
    fi
  done
  $skip && continue

  TARGET=~/"$FILE_BASENAME"

  # Skip if target already points to the same file
  if [ -e "$TARGET" ] && [ "$(realpath "$file")" == "$(realpath "$TARGET" 2>/dev/null)" ]; then
    echo "skip: (same as target) ${FILE_BASENAME}"
    continue
  fi

  ln ${LN_OPTS} "$file" "$TARGET"
done
