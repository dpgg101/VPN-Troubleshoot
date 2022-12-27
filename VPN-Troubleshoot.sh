#!/bin/bash
VERSION=0.1
Author=dpgg


### Colours ###
RED="\033[01;31m"
GREEN="\033[0;32m"
ORG="\033[00m" ## Original color 
YELLOW="\033[0;33m"

## Get user and UID ##
_user="$(id -u -n)"
_uid="$(id -u)"
_group="$(groups | awk '{print $1}')"

## User enum
echo -e "${GREEN} ====== USER RECON ====== ${ORG}"
echo -e "User name:${RED} $_user ${ORG}"
echo -e "User name ID (UID):${RED} $_uid ${ORG}"
echo -e "Group:${RED} $_group${ORG}\n"

## VPN enum
echo -e "${GREEN}====== VPN Enum ======${ORG}"

if (ip a | grep -iq tun); then
	echo -e "You appear to be connected to the VPN.${YELLOW}"; ip a | grep tun | awk '{print $2}' | sed 'N;s/\n/ /'; echo -e "${ORG}"
    else
	        echo -e "${RED}You do not appear to be connected to the VPN. ${ORG}"
	 sleep 1s
 exit 1
fi

_vpnf="$(find / -name '*.ovpn' 2>/dev/null)"
echo -e "${GREEN}====== VPN Files ======${ORG}\n${RED}$_vpnf ${ORG}\n"

## Routes enum
echo -e "${GREEN}====== IP Routes Enum ======${ORG}"; ip route

## Machine accessibility checks

echo -e "\n${GREEN}====== Target availability ======${ORG}"
read -p "Enter the IP address of the target: " target; ping -c4 $target
echo -e "\n"; traceroute $target
