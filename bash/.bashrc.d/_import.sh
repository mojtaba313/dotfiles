#!/usr/bin/env bash
# _import.sh — source every *.sh in ~/.bashrc.d (except itself)
# spacesafe, sorted, silent on missing dir

BASHRC_D_DIR="$HOME/.bashrc.d"

if [ -L "$BASHRC_D_DIR" ]; then
    BASHRC_D_DIR="$(readlink -f "$BASHRC_D_DIR")"
fi

if [ -d "$BASHRC_D_DIR" ]; then
    while IFS= read -r file; do
        [ -e "$file" ] && [ -r "$file" ] || continue
        # shellcheck source=/dev/null
        source "$file"
    done < <(find "$BASHRC_D_DIR" -maxdepth 1 -type f -name "*.sh" ! -name "_import.sh" | sort)
fi
