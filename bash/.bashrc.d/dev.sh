# ~/.bashrc.d/dev.sh — dotfiles + web-dev shortcuts
# stow helpers + git/docker/node/productivity

# --- dotfiles ---
alias dot='cd ~/dotfiles'
alias stow-hypr='cd ~/dotfiles && stow hypr'
alias stow-all='cd ~/dotfiles && stow --restow */'
alias s='source ~/.bashrc'
alias hreload='hyprctl reload'
# bar control (state-aware; SUPER+Z / SUPER+SHIFT+B do the same)
alias bar='~/.config/hypr/scripts/barctl.sh'
alias wtoggle='~/.config/hypr/scripts/barctl.sh toggle'
alias wshow='~/.config/hypr/scripts/barctl.sh show'
alias whide='~/.config/hypr/scripts/barctl.sh hide'
# waybar signals: SIGUSR2 = reload in place (no restart), SIGUSR1 = toggle
alias wreload='pkill -SIGUSR2 waybar'
# clipboard with pins
alias clip='~/.config/hypr/scripts/clipmenu.sh'
alias clips='~/.config/hypr/scripts/clipmenu.sh --pinned'

# --- git (short, safe) ---
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull --ff-only'
alias gd='git diff'
alias gds='git diff --staged'
alias glg='git log --oneline --graph --decorate -15 --all'
alias gco='git checkout'
alias gsw='git switch'
alias gbr='git branch -vv'
alias gstash='git stash -u -m'
alias gpop='git stash pop'

# --- docker ---
alias d='docker'
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dimg='docker images'

# --- node / pnpm (web dev) ---
alias pi='pnpm install'
alias dev='pnpm dev'
alias build='pnpm build'
alias start='pnpm start'
alias pre='pnpm preview'
alias ptest='pnpm test'
alias nx='pnpm dlx'
alias npxf='npx --yes'

# --- ports / serve ---
alias ports='ss -tulpn | grep LISTEN'
alias serve='python3 -m http.server 8000'

# --- editors ---
alias v='nvim'
alias vscode='code . &>/dev/null & disown'

# --- copy std output to clipboard ---
alias c='wl-copy -n'

# --- vnc ---
alias vnc='wayvnc -o LVDS-1 0.0.0.0 5900'
