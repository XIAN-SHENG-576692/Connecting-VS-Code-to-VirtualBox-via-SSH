#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)

$SCRIPT_DIR/sshd_add_pub_key.sh
$SCRIPT_DIR/setup_podman.sh
$SCRIPT_DIR/copy_ssh_files.sh
$SCRIPT_DIR/setup_ssh-agent.sh
