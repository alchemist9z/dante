#!/bin/bash

# Check if the script is executed by the root user
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Check if iptables is installed
if command -v iptables &> /dev/null; then
    echo "Using iptables"
    # Enable port 26257 for incoming traffic
    iptables -I INPUT -p tcp --dport 26257 -j ACCEPT
    iptables -I INPUT -p udp --dport 26257 -j ACCEPT
    # Enable port 26257 for outgoing traffic
    iptables -I OUTPUT -p tcp --dport 26257 -j ACCEPT
    iptables -I OUTPUT -p udp --dport 26257 -j ACCEPT
fi

# Check if UFW is installed
if command -v ufw &> /dev/null; then
    echo "Using UFW"
    # Allow port 26257
    ufw allow 26257/tcp
    ufw allow 26257/udp
fi

# Check if firewalld is installed and running
if command -v firewall-cmd &> /dev/null && systemctl is-active --quiet firewalld; then
    echo "Using firewalld"
    # Allow port 26257
    firewall-cmd --zone=public --add-port=26257/tcp --permanent
    firewall-cmd --zone=public --add-port=26257/udp --permanent
    firewall-cmd --reload
fi
