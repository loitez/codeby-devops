#!/bin/bash
set -e

DOMAIN="loitez.local"
WWW_DOMAIN="www.${DOMAIN}"
CERT_DIR="/etc/ssl/${DOMAIN}"
APACHE_CONF="/etc/apache2/sites-available"

# Обновление и установка Apache
apt update && apt upgrade -y
apt install -y apache2 openssl

# Создание директории для сертификатов
mkdir -p ${CERT_DIR}

# Генерация self-signed сертификата
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ${CERT_DIR}/private.key \
  -out ${CERT_DIR}/certificate.crt \
  -subj "/C=RU/ST=Moscow/L=Moscow/O=Dev/CN=${DOMAIN}" \
  -addext "subjectAltName=DNS:${DOMAIN},DNS:${WWW_DOMAIN}"

# Настройка прав
chmod 600 ${CERT_DIR}/private.key
chmod 644 ${CERT_DIR}/certificate.crt

# Включение модулей Apache
a2enmod ssl rewrite

# Конфигурация HTTP → HTTPS + www → non-www
cat > ${APACHE_CONF}/000-default.conf << EOF
<VirtualHost *:80>
    ServerName ${DOMAIN}
    ServerAlias ${WWW_DOMAIN}

    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^www\.${DOMAIN} [NC]
    RewriteRule ^(.*)$ https://${DOMAIN}/\$1 [R=301,L]

    RewriteCond %{HTTPS} off
    RewriteRule ^(.*)$ https://${DOMAIN}/\$1 [R=301,L]
</VirtualHost>
EOF

# Конфигурация HTTPS
cat > ${APACHE_CONF}/default-ssl.conf << EOF
<IfModule mod_ssl.c>
<VirtualHost *:443>
    ServerName ${DOMAIN}
    ServerAlias ${WWW_DOMAIN}
    DocumentRoot /var/www/html

    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^www\.${DOMAIN} [NC]
    RewriteRule ^(.*)$ https://${DOMAIN}/\$1 [R=301,L]

    SSLEngine on
    SSLCertificateFile ${CERT_DIR}/certificate.crt
    SSLCertificateKeyFile ${CERT_DIR}/private.key

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/ssl_error.log
    CustomLog \${APACHE_LOG_DIR}/ssl_access.log combined
</VirtualHost>
</IfModule>
EOF

# Включение SSL-сайта и перезапуск Apache
a2ensite default-ssl
systemctl restart apache2
systemctl enable apache2

# Копируем сертификат в /vagrant для доступа с client
cp ${CERT_DIR}/certificate.crt /vagrant/${DOMAIN}.crt

echo "✅ Server настроен. Доступен по: https://${DOMAIN}"