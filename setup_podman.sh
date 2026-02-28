#!/bin/sh

# Check if podman is already installed
if ! [ -x "$(command -v podman)" ]; then
    echo "Error: podman is not installed."
    exit 1
else
    # Display the installed version
    echo "Podman detected: $(podman --version)"
fi

# Configure Rootless subuid/subgid (Skip if user is root)
CURRENT_USER=$(whoami)
if [ "$CURRENT_USER" = "root" ]; then
    echo "Running as root. Skipping subuid/subgid configuration."
else
    if ! grep -q "$CURRENT_USER" /etc/subuid 2>/dev/null; then
        echo "Configuring subuid/subgid for $CURRENT_USER..."
        sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$CURRENT_USER"
    else
        echo "Rootless mapping for $CURRENT_USER already exists."
    fi
fi

# Handle Service Initiation for OpenRC (Alpine, etc.)
if [ -x "$(command -v openrc)" ] || [ -f "/sbin/openrc" ]; then
    echo "Init: openrc detected. Starting Podman socket..."
    sudo rc-update add cgroups default
    sudo rc-service cgroups start
    sudo rc-service podman start

# Handle Service Initiation for systemd (Debian, Ubuntu, Fedora, etc.)
elif [ -x "$(command -v systemctl)" ]; then
    echo "Init: systemd detected. Starting Podman socket..."
    sudo systemctl enable --now podman.socket
fi

echo "Podman environment check and service initiation complete."
