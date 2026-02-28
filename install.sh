#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root (e.g., using sudo)."
    exit 1
fi

# Get packages to download; defaults to "sudo" if no argument is provided
PACKAGES=${1:-"sudo"}

if [ -x "$(command -v apt-get)" ]; then
    echo "System: Debian/Ubuntu series"
    export DEBIAN_FRONTEND=noninteractive
    
    apt-get update
    apt-get install -y --no-install-recommends $PACKAGES
    
    # Cleanup: remove cache and temporary lists to save space
    apt-get clean
    rm -rf /var/lib/apt/lists/*

elif [ -x "$(command -v apk)" ]; then
    echo "System: Alpine series"
    # --no-cache avoids generating local cache files
    apk add --no-cache $PACKAGES

elif [ -x "$(command -v dnf)" ]; then
    echo "System: RHEL/Fedora series (dnf)"
    dnf install -y $PACKAGES
    dnf clean all

elif [ -x "$(command -v yum)" ]; then
    echo "System: RHEL/CentOS series (yum)"
    yum install -y $PACKAGES
    yum clean all

else
    echo "Error: Unsupported package manager"
    exit 1
fi
