# ~/.bashrc.d/network.sh — proxy / vpn helpers
# keeps your v2rayN workflow, adds clean status

vpn() {
    if [ "$1" = "on" ]; then
        export http_proxy="http://127.0.0.1:10808"
        export https_proxy="http://127.0.0.1:10808"
        export all_proxy="socks5://127.0.0.1:10808"
        export no_proxy="localhost,127.0.0.1"
        echo "✓ VPN Proxy ON (:10808)"
    elif [ "$1" = "off" ]; then
        unset http_proxy https_proxy all_proxy
        echo "✗ VPN Proxy OFF"
    elif [ "$1" = "status" ]; then
        if [ -n "${http_proxy:-}" ]; then
            echo "✓ ON  http_proxy=$http_proxy"
        else
            echo "✗ OFF (no proxy env set)"
        fi
    else
        echo "Usage: vpn on | off | status"
    fi
}

# quick check: am I proxied? what's my ip?
alias myip='curl -s ifconfig.me; echo'
alias myip-proxy='https_proxy=http://127.0.0.1:10808 http_proxy=http://127.0.0.1:10808 curl -s ifconfig.me; echo'
