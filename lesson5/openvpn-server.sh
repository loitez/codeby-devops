#!/bin/bash
set -e

apt-get update
apt-get install -y openvpn easy-rsa

mkdir -p /etc/openvpn/server
mkdir -p /etc/openvpn/easy-rsa
mkdir -p /vagrant/vpn-keys

cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/
cd /etc/openvpn/easy-rsa

./easyrsa init-pki

./easyrsa build-ca nopass <<EOF
OpenVPN-CA
EOF

./easyrsa gen-req server nopass <<EOF
server
EOF
./easyrsa sign-req server server <<EOF
yes
EOF

./easyrsa gen-req client nopass <<EOF
client
EOF
./easyrsa sign-req client client <<EOF
yes
EOF

./easyrsa gen-dh

openvpn --genkey --secret /etc/openvpn/server/ta.key

cp /etc/openvpn/easy-rsa/pki/ca.crt /vagrant/vpn-keys/
cp /etc/openvpn/easy-rsa/pki/issued/client.crt /vagrant/vpn-keys/
cp /etc/openvpn/easy-rsa/pki/private/client.key /vagrant/vpn-keys/
cp /etc/openvpn/server/ta.key /vagrant/vpn-keys/

cat > /etc/openvpn/server/server.conf <<EOF
port 1194
proto udp
dev tun
ca /etc/openvpn/easy-rsa/pki/ca.crt
cert /etc/openvpn/easy-rsa/pki/issued/server.crt
key /etc/openvpn/easy-rsa/pki/private/server.key
dh /etc/openvpn/easy-rsa/pki/dh.pem
tls-auth /etc/openvpn/server/ta.key 0
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
cipher AES-256-GCM
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
verb 3
EOF

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -A INPUT -p udp --dport 1194 -j ACCEPT

systemctl -f enable openvpn-server@server
systemctl start openvpn-server@server

echo "✅ OpenVPN Server готов!"