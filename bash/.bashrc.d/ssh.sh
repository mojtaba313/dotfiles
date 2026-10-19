# Auto-start ssh-agent
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
fi

# Add keys
ssh-add ~/.ssh/id_ed25519_github 2>/dev/null