# ~/.bashrc.d/functions.sh — small sharp tools

# make dir + cd
mkcd() {
    mkdir -p -- "$1" && cd -- "$1" || return
}

# backup a file with timestamp
bak() {
    cp -a -- "$1" "$1.$(date +%Y%m%d-%H%M%S).bak" && echo "backed up → $1.$(date +%Y%m%d-%H%M%S).bak"
}

# extract anything
extract() {
    local f="$1"
    [ -f "$f" ] || { echo "extract: '$f' not found"; return 1; }
    case "$f" in
        *.tar.bz2|*.tbz2) tar xjf "$f" ;;
        *.tar.gz|*.tgz)   tar xzf "$f" ;;
        *.tar.xz|*.txz)   tar xJf "$f" ;;
        *.tar)            tar xf "$f" ;;
        *.zip)            unzip "$f" ;;
        *.rar)            unrar x "$f" ;;
        *.7z)             7z x "$f" ;;
        *.gz)             gunzip "$f" ;;
        *.bz2)            bunzip2 "$f" ;;
        *) echo "extract: unknown format '$f'" ;;
    esac
}

# find process listening on port: port 3000
port() {
    ss -tulpn | grep -E ":$1([^0-9]|$)" || echo "nothing on :$1"
}

# kill process on port: killport 3000
killport() {
    local pids
    pids=$(ss -tulpn 2>/dev/null | grep -E ":$1([^0-9]|$)" | grep -oP 'pid=\K[0-9]+' | sort -u)
    if [ -z "$pids" ]; then echo "nothing on :$1"; return 1; fi
    echo "$pids" | xargs kill -15 && echo "killed on :$1 → $pids"
}

# pretty json log tail for dev servers
jlog() {
    if command -v jq >/dev/null 2>&1; then jq -R 'fromjson? // .'; else cat; fi
}

# weather for on-call commutes (Tehran default? override: weather Berlin)
weather() {
    curl -s "wttr.in/${1:-}?format=3"
}
