#!/bin/bash
set -e
sleep 30

apt-get update
apt-get install -y openvpn

mkdir -p /etc/openvpn/client
mkdir -p /vagrant/vpn-keys

echo "⏳ Ожидание ключей..."
sleep 5

cp /vagrant/vpn-keys/ca.crt /etc/openvpn/client/
cp /vagrant/vpn-keys/client.crt /etc/openvpn/client/
cp /vagrant/vpn-keys/client.key /etc/openvpn/client/
cp /vagrant/vpn-keys/ta.key /etc/openvpn/client/

cat > /etc/openvpn/client/client.conf <<EOF
client
dev tun
proto udp
remote 192.168.56.11 1194
resolv-retry infinite
nobind
user nobody
group nogroup
persist-key
persist-tun
ca ca.crt
cert client.crt
key client.key
tls-auth ta.key 1
cipher AES-256-GCM
verb 3
redirect-gateway def1
dhcp-option DNS 8.8.8.8
dhcp-option DNS 8.8.4.4
EOF

systemctl -f enable openvpn-client@client
systemctl start openvpn-client@client

sleep 3
echo "=== Проверка подключения ==="
ip addr show tun0 || echo "⚠️ tun0 не создан"

echo "✅ OpenVPN Client готов!"