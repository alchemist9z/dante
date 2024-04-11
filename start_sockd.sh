#!/bin/bash

# Check if the user is root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi

# Check if sockd daemon is available
if ! command -v systemctl &> /dev/null; then
    echo "systemctl command not found. Cannot manage services."
    exit 1
fi

# Check the status of sockd service
status=$(systemctl is-active sockd.service)

if [[ $status != "active" ]]; then
    # Start sockd service if it's not active
    systemctl start sockd.service
    echo "sockd service started."
else
    echo "sockd service is already active."
fi
