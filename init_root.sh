#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)

$SCRIPT_DIR/install.sh sudo
$SCRIPT_DIR/install.sh podman
$SCRIPT_DIR/vbox_permanent_shares.sh
$SCRIPT_DIR/setup_sshd.sh

# (Optional): Additional tools.
$SCRIPT_DIR/install.sh dos2unix
