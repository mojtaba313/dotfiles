# ~/.bashrc.d/customes.sh — base shell (Abyss Cyan)
# preserved from your setup: starship, vpn, nvm, pnpm, code, pipx

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- history: big, shared, no dupes ---
export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend checkwinsize globstar 2>/dev/null || true

# --- colors ---
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'

# fallback prompt (starship overrides when available)
PS1='[\u@\h \W]\$ '

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# --- editor ---
export EDITOR="${EDITOR:-nvim}"
export VISUAL="$EDITOR"

# --- v2RayN ---
export PATH="$PATH:/usr/local/bin/v2rayN-linux-64"
alias v2="v2rayN & disown"
# --- vscode ---
export PATH="$PATH:/usr/share/code/"

# --- nvm ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- pnpm ---
export PNPM_HOME="/home/mojtaba/.local/share/pnpm:/home/mojtaba/.local/share/pnpm/bin"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- pipx / local bin ---
export PATH="$PATH:/home/mojtaba/.local/bin"

# --- opencode ---
alias open=opencode

# --- QoL ---
alias line_code="git ls-files | xargs wc -l | sort -nr"
alias gitdiff="git diff --color=always | less -R"
