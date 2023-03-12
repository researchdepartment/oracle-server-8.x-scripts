```bash
#!/bin/bash
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
subscription-manager repos --enable codeready-builder-for-rhel-8-$(arch)-rpms
yum copr enable jdoss/wireguard
yum install wireguard-dkms wireguard-tools

rpm -qa | grep wireguard
modinfo wireguard

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf

cd /etc/wireguard
umask 077
wg genkey | tee privatekey | wg pubkey > publickey

firewall-cmd --zone=public --permanent --add-port=51820/tcp
firewall-cmd --zone=public --permanent --add-port=51820/udp
firewall-cmd --reload
```

# example server config (/etc/wireguard/wg0.conf):
```
[Interface]
Address = 10.0.0.4/32
SaveConfig = false
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eno1 -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o eno1 -j MASQUERADE
ListenPort = 51820
PrivateKey = contents of /etc/wireguard/privatekey on the server

[Peer]
PublicKey = contents of /etc/wireguard/publickey on the client
AllowedIPs = 10.0.0.3/32
Endpoint = client ip:51821
PersistentKeepalive = 25
```

# example client config (/etc/wireguard/wg0.conf):
```
[Interface]
Address = 10.0.0.3/32
SaveConfig = false
ListenPort = 51821
PrivateKey = contents of /etc/wireguard/privatekey on the client

[Peer]
PublicKey = contents of /etc/wireguard/publickey on the server
AllowedIPs = 10.0.0.4/32
Endpoint = server ip:51820
PersistentKeepalive = 25

```bash
#!/bin/bash
service wg-quick@wg0 enable
service wg-quick@wg0 start
```