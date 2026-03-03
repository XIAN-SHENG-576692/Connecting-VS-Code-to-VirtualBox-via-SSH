#!/bin/bash

# Prompt the user for the source directory path
echo "Please enter the full path of the directory containing your files:"
read -r source_path

# Expand tilde (~) if the user used it in the input
source_path=$(eval echo "$source_path")

# Check if the source directory actually exists
if [ ! -d "$source_path" ]; then
    echo "Error: Directory '$source_path' does not exist."
    exit 1
fi

# Ensure the destination directory exists
mkdir -p "$HOME/.ssh"

# Copy all files from the source to ~/.ssh
# Using -v to show progress
cp -v "$source_path"/* "$HOME/.ssh/"

# Set secure permissions
echo "Setting secure permissions..."
chmod 700 "$HOME/.ssh"
chmod 600 "$HOME/.ssh"/*

echo "------------------------------------------------"
echo "Task complete. Files copied and permissions secured (700 for dir, 600 for files)."
