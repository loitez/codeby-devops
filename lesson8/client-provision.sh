#!/bin/bash
set -e

DOMAIN="loitez.local"
SERVER_IP="192.168.56.10"
CERT_DIR="/usr/local/share/ca-certificates"

# /etc/hosts
grep -q "${DOMAIN}" /etc/hosts || echo "${SERVER_IP} ${DOMAIN} www.${DOMAIN}" >> /etc/hosts

# Получить сертификат напрямую с сервера
echo "🔐 Получение сертификата с ${SERVER_IP}..."
echo | openssl s_client -connect "${SERVER_IP}:443" -servername "${DOMAIN}" 2>/dev/null \
  | openssl x509 -out "${CERT_DIR}/${DOMAIN}.crt"

# Установить как доверенный
update-ca-certificates

echo "✅ Client настроен. Проверка: curl https://${DOMAIN}"