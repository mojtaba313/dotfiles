#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

eval "$(starship init bash)"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
#alias clear='printf "\033[2J\033[3J\033[H"'
#alias cl='printf "\033[2J\033[3J\033[H"'
alias gitdiff="git diff --color=always | less -R"


# v2RayN
export PATH="$PATH:/usr/local/bin/v2rayN-linux-64"
vpn() {
    if [ "$1" = "on" ]; then
        export http_proxy="http://127.0.0.1:10808"
        export https_proxy="http://127.0.0.1:10808"
        export all_proxy="socks5://127.0.0.1:10808"
        export no_proxy="localhost,127.0.0.1"
        echo "✓ VPN Proxy ON"
    elif [ "$1" = "off" ]; then
        unset http_proxy https_proxy all_proxy
        echo "✗ VPN Proxy OFF"
    else
        echo "Usage: vpn on  or  vpn off"
    fi
}

# vscode
export PATH="$PATH:/usr/share/code/"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opencode-ai
alias open=opencode

# pnpm
export PNPM_HOME="/home/mojtaba/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
#
# count lines of code
alias line_code="git ls-files | xargs wc -l | sort -nr"

# Created by `pipx` on 2026-08-15 15:29:16
export PATH="$PATH:/home/mojtaba/.local/bin"

alias cleara="printf '\e[H\e[3J'"
