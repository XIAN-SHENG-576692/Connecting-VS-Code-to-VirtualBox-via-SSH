#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)

echo "--- Setting up SSH Authorized Keys ---"
read -p "Paste your SSH Public Key OR the local path to your .pub file (or press Enter to skip): " PUB_KEY

if [ -n "$PUB_KEY" ]; then
    # Determine the actual user (even if running via sudo)
    REAL_USER="${SUDO_USER:-$USER}"
    USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
    SSH_DIR="$USER_HOME/.ssh"
    AUTH_KEYS="$SSH_DIR/authorized_keys"

    # Create the .ssh directory if it doesn't exist
    mkdir -p "$SSH_DIR"

    # --- Logic to handle file path vs. raw string ---
    if [ -f "$PUB_KEY" ]; then
        # If the input is an existing file, read its content
        cat "$PUB_KEY" >> "$AUTH_KEYS"
        echo "Public key successfully added from file: $PUB_KEY"
    else
        # If the input is a string, append it directly
        echo "$PUB_KEY" >> "$AUTH_KEYS"
        echo "Public key string successfully added."
    fi
    
    # Set correct permissions (Critical for SSH Key login)
    chmod 700 "$SSH_DIR"
    chmod 600 "$AUTH_KEYS"
    chown -R "$REAL_USER:$REAL_USER" "$SSH_DIR"
    echo "Public key successfully added for user: $REAL_USER"
fi

sudo $SCRIPT_DIR/restart_sshd.sh
