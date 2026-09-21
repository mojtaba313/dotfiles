#!/usr/bin/env bash

BASHRC_D_DIR="$HOME/.bashrc.d"

if [ -L "$BASHRC_D_DIR" ]; then
    BASHRC_D_DIR="$(readlink -f "$BASHRC_D_DIR")"
fi

if [ -d "$BASHRC_D_DIR" ]; then
    for file in $(find "$BASHRC_D_DIR" -maxdepth 1 -name "*.sh" ! -name "_import.sh" | sort); do
        if [ -e "$file" ] && [ -r "$file" ]; then
            # shellcheck source=/dev/null
            source "$file"
        fi
    done
fi
