#!/bin/bash
set -e # Выход при любой ошибке

# --- Конфигурация ---
BACKUP_DIR="/opt/mysql_backup"
STORE_USER="vagrant"
STORE_IP="192.168.33.11"
STORE_DIR="/opt/store/mysql"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
DB_NAME="test_db"
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${DATE}.sql"

# Явно задаем PATH для cron
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# --- 1. Создание бэкапа ---
echo "Начало бэкапа: $DATE"

mkdir -p "$BACKUP_DIR"

# Используем абсолютный путь к mysqldump для надежности в cron
if /usr/bin/mysqldump --defaults-file=/home/vagrant/.my.cnf --no-tablespaces "$DB_NAME" > "$BACKUP_FILE" 2>/tmp/mysqldump_err.log; then
    echo "Бэкап успешно создан: $BACKUP_FILE"

    # Сжатие с проверкой
    if gzip -f "$BACKUP_FILE"; then
        BACKUP_FILE="${BACKUP_FILE}.gz"
    else
        echo "Ошибка сжатия!"
        exit 1
    fi
else
    echo "Ошибка создания бэкапа! См. /tmp/mysqldump_err.log"
    cat /tmp/mysqldump_err.log
    exit 1
fi

# --- 2. Синхронизация через rsync ---
echo "Начало синхронизации с store..."

# Проверяем доступность store перед синхронизацией
if ! ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$STORE_USER@$STORE_IP" "exit" 2>/dev/null; then
    echo "Warning: Store недоступен, пропускаем синхронизацию."
    # Не выходим с ошибкой, чтобы локальный бэкап сохранился
else
    # Создаем директорию на store
    ssh -o StrictHostKeyChecking=no "$STORE_USER@$STORE_IP" "mkdir -p $STORE_DIR"

    # Копируем файл
    if rsync -avz -e "ssh -o StrictHostKeyChecking=no" "$BACKUP_FILE" "$STORE_USER@$STORE_IP:$STORE_DIR/"; then
        echo "Синхронизация завершена успешно."
    else
        echo "Ошибка синхронизации!"
        exit 1
    fi
fi

# --- 3. Очистка старых бэкапов (храним последние 24 часа) ---
if [ -d "$BACKUP_DIR" ]; then
    find "$BACKUP_DIR" -type f -mmin +1440 -delete
    echo "Старые бэкапы очищены."
fi