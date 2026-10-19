# ~/.bashrc.d/aliases.sh — safe + modern defaults

# --- safety ---
alias rm='rm -I'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# --- navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# --- quick views ---
alias cl='clear'
alias cla="printf '\e[H\e[3J'"

# --- modern replacements (graceful fallback) ---
if command -v eza >/dev/null 2>&1; then
    alias ll='eza -lh --group-directories-first --icons always'
    alias la='eza -lah --group-directories-first --icons always'
    alias lt='eza -T --level=2 --icons always'
else
    alias ll='ls -lh'
    alias la='ls -lah'
fi

if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
elif command -v batcat >/dev/null 2>&1; then
    alias cat='batcat --paging=never'
fi

# --- disk / mem quick views ---
alias df='df -h'
alias du='du -h'
alias free='free -h'

# nmcli
alias up='nmcli connection up'
