#!/bin/bash

# Refers to [Sharing Git credentials with your container](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials)

# Define marker to identify if the script has already been added
MARKER="# --- SSH Agent Auto-Launch ---"
TARGET_FILE="$HOME/.bashrc"
AGENT_FILE="$HOME/.ssh/ssh-agent"

# Ensure .ssh directory exists with correct permissions
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Check if the marker already exists in the target file
if grep -q "$MARKER" "$TARGET_FILE" 2>/dev/null; then
    echo "Notice: Content already exists in $TARGET_FILE. Skipping write."
else
    echo "Writing SSH Agent script to $TARGET_FILE..."
    cat << EOF >> "$TARGET_FILE"

$MARKER
if [ -z "\$SSH_AUTH_SOCK" ]; then
    # Check for a currently running instance of the agent
    RUNNING_AGENT="\$(ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]')"
    if [ "\$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &> $AGENT_FILE
    fi
    eval \$(cat $AGENT_FILE) > /dev/null
    # Find files in .ssh, excluding public keys and common config files
    # Then verify if the file actually contains a PRIVATE KEY header
    for file in \$(find "\$HOME/.ssh" -type f ! -name "*.pub" ! -name "config" ! -name "known_hosts" ! -name "authorized_keys"); do
        if grep -q "PRIVATE KEY" "\$file" 2>/dev/null; then
            ssh-add "\$file" 2> /dev/null
        fi
    done
fi
# -----------------------------
EOF
    echo "Success: Script written to $TARGET_FILE."
fi

# Load the file into the current shell session
if [ -f "$TARGET_FILE" ]; then
    . "$TARGET_FILE"
    echo "Script has been sourced and is now active."
fi
