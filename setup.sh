#!/bin/bash

# Get the directory where this script resides
SCRIPT_DIR=$(cd "$(dirname "$0")" || exit; pwd)
# shellcheck disable=SC2128

# Set symlink options depending on the OS
case $(uname) in
  Darwin)
    LN_OPTS="-sv"
    ;;
  Linux)
    LN_OPTS="-sv --backup=numbered"
    ;;
esac

# List of files/patterns to exclude from linking
EXCLUDES=(
  ".DS_Store"
  ".gitignore"
  ".pre-commit-config.yaml"
  ".secrets.baseline"
  "*.swp"
)

# Initialize the array for symlink target pairs
TARGETS=()

# abbr
echo "Generating .abbrs from .aliases..."
ABBR_FILE="${SCRIPT_DIR}/.abbrs"
echo "# Auto-generated from .aliases on $(date)" > "$ABBR_FILE"
echo "if [ ! -s \$HOME/.config/zsh-abbr/user-abbreviations ]; then" >> "$ABBR_FILE"
echo "abbr --quiet -g g=git" >> "$ABBR_FILE"
echo "abbr --quiet import-git-aliases -g --prefix 'git '" >> "$ABBR_FILE"
awk '
/^[[:space:]]*#/ {next}
/^[[:space:]]*alias[[:space:]]+/ {
  sub(/^[[:space:]]*alias[[:space:]]+/, "")
  split($0, a, "=")
  print "abbr " a[1] "=" a[2]
}
' "${SCRIPT_DIR}/.aliases" >> "$ABBR_FILE"
echo "fi" >> "$ABBR_FILE"

# Process dotfiles in the script directory
for file in "${SCRIPT_DIR}"/.*; do
  [ -f "$file" ] || continue  # Skip if not a regular file
  FILE_BASENAME=$(basename -- "$file")

  # Skip files that match any exclude pattern
  for pattern in "${EXCLUDES[@]}"; do
    [[ "$FILE_BASENAME" == $pattern ]] && continue 2
  done

  # Add source:destination pair to TARGETS array
  TARGETS+=("$file:$HOME/$FILE_BASENAME")
done

# Handle NeoVim configuration directory
if [ -n "$XDG_CONFIG_HOME" ]; then
  NVIM_HOME="$XDG_CONFIG_HOME/nvim"
else
  NVIM_HOME="$HOME/.config/nvim"
fi
mkdir -p "$NVIM_HOME"

# Add NeoVim config files to the TARGETS list
for item in init.lua lua; do
  SRC="$SCRIPT_DIR/$item"
  [ -e "$SRC" ] && TARGETS+=("$SRC:$NVIM_HOME/$item")
done

# Create symlinks
for pair in "${TARGETS[@]}"; do
  SRC="${pair%%:*}"
  DEST="${pair#*:}"

  # Skip if destination already points to the same file
  if [ -e "$DEST" ] && [ "$(realpath "$SRC")" == "$(realpath "$DEST" 2>/dev/null)" ]; then
    echo "skip: (same as target) $(basename "$DEST")"
    continue
  fi

  # Create the symbolic link
  ln ${LN_OPTS} "$SRC" "$DEST"
done
