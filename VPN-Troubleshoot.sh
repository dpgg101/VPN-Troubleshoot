#!/bin/bash
#Author: dpgg

# Define colors for output text
RED="\033[01;31m"
GREEN="\033[0;32m"
ORG="\033[00m" # Original color
YELLOW="\033[0;33m"

# Get current user and UID
user=$(id -u -n)
uid=$(id -u)
group=$(groups | awk '{print $1}')

# Print user information
echo -e "${GREEN} ====== USER RECON ====== ${ORG}"
echo -e "User name: ${RED}$user${ORG}"
echo -e "User name ID (UID): ${RED}$uid${ORG}"
echo -e "Group: ${RED}$group${ORG}"

# Check VPN connection
echo -e "${GREEN}====== VPN Enum ======${ORG}"
vpn_interfaces=$(ip a | grep -ci tun)
if [ "$vpn_interfaces" -gt 1 ]; then
    if [ "$vpn_interfaces" -gt 2 ]; then
        echo -e "${YELLOW}Warning: Multiple VPN interfaces detected.${ORG}"
    fi
    echo -e "You appear to be connected to the VPN."
    ip a | grep tun | awk '{print $2}' | sed 'N;s/\n/ /'
else
    echo -e "${RED}You do not appear to be connected to the VPN. ${ORG}"
fi

# Prompt for OpenVPN configuration file location
echo -e "${GREEN}====== VPN Connection File and Server Name ======${ORG}"
read -p "Enter the path to the OpenVPN configuration file: " vpn_file
if [ -f "$vpn_file" ]; then
    echo -e "${RED}$vpn_file${ORG}"
    vpn_server=$(grep '^remote ' "$vpn_file" | awk '{print $2}')
    echo -e "VPN server name: ${RED}$vpn_server${ORG}"
else
    echo -e "${RED}Unable to determine the file used to connect to the VPN.${ORG}"
fi
# Display IP routes
echo -e "${GREEN}====== IP Routes Enum ======${ORG}"
ip route

# Prompt for target IP address and check reachability
echo -e "\n${GREEN}====== Target availability ======${ORG}"
read -p "Enter the IP address of the target: " target
if ping -c4 "$target" &> /dev/null; then
    echo -e "${GREEN}The target is reachable.${ORG}"
else
    echo -e "${RED}The target is not reachable.${ORG}"
fi
traceroute "$target"

# Perform fast scan on top 1000 ports
echo -e "\n${GREEN}====== Fast scan on top 1000 ports ======${ORG}"
sudo nmap -T4 -A $target
