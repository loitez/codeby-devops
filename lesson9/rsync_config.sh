# Конфигурация синхронизации rsync
STORE_USER=vagrant
STORE_IP=192.168.33.11
STORE_DIR=/opt/store/mysql
SSH_OPTIONS="-o StrictHostKeyChecking=no"
RSYNC_FLAGS="-avz"
BACKUP_DIR="/opt/mysql_backup"