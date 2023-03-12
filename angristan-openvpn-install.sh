#!/bin/bash
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh

./openvpn-install.sh

# DNS resolution fix?
systemctl disable firewalld
systemctl stop firewalld

sed -i "s|Before|After|i" /etc/systemd/system/iptables-openvpn.service
systemctl daemon-reload
systemctl restart iptables-openvpn.service

# disable logging
sed -i "s|verb |verb 0 #verb |i" /etc/openvpn/server.conf
systemctl restart openvpn-server@server.service