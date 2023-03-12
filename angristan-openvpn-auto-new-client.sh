#!/bin/bash

## Make a new passwordless client with an automatically generated name.
## Automatically completes the following:
# What do you want to do?
#    1) Add a new user
#    2) Revoke existing user
#    3) Remove OpenVPN
#    4) Exit
# 
# Tell me a name for the client.
# The name must consist of alphanumeric character. It may also include an underscore or a dash.
# 
# Do you want to protect the configuration file with a password?
# (e.g. encrypt the private key with a password)
#    1) Add a passwordless client
#    2) Use a password for the client

# https://github.com/angristan/openvpn-install
# https://gist.github.com/researcx

country=$(curl -s ipinfo.io | grep country | cut -d '"' -f4)
shufrand=$(shuf -i 1-65000 -n 1)
configname=$country-$hostname-$shufrand # example: GB-datacenter-3021

if [ "${SUDO_USER}" ]; then
    # if not, use SUDO_USER
    if [ "${SUDO_USER}" == "root" ]; then
        # If running sudo as root
        homeDir="/root"
    else
        homeDir="/home/${SUDO_USER}"
    fi
else
    # if not SUDO_USER, use /root
    homeDir="/root"
fi

echo "1
$configname
1" | ./openvpn-install.sh
cat $homeDir/$configname.ovpn