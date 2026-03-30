#!/bin/bash
# Скрипт создания тестовой структуры файлов
# Версия: 1.1

# Константы
readonly FOLDER_NAME="my_folder"
readonly FILE_PERMS="777"
readonly RANDOM_LENGTH=20
readonly TARGET_DIR="$HOME/$FOLDER_NAME"

readonly EXIT_SUCCESS=0
readonly EXIT_FAILURE=1

# 1. Создание директории с проверкой ошибки
if ! mkdir -p "$TARGET_DIR"; then
    echo "[ERROR] Не удалось создать директорию $TARGET_DIR" >&2
    exit $EXIT_FAILURE
fi
echo "[OK] Директория создана: $TARGET_DIR"

# 2. Файл с датой
CURRENT_DATE=$(date "+%Y-%m-%d")
echo -e "Hello world!\n$CURRENT_DATE" > "$TARGET_DIR/hello.txt"

# 3. Файл со случайной строкой
if ! </dev/urandom tr -dc 'A-Za-z0-9!@#$%^&*()' | head -c "$RANDOM_LENGTH" > "$TARGET_DIR/random.txt"; then
    echo "[ERROR] Не удалось записать случайную строку" >&2
    exit $EXIT_FAILURE
fi

# 4. Файл с правами доступа
touch "$TARGET_DIR/empty_file_rights.txt"
chmod "$FILE_PERMS" "$TARGET_DIR/empty_file_rights.txt"

# 5. Пустые файлы (создаем одной командой)
touch "$TARGET_DIR/empty_file.txt" "$TARGET_DIR/empty_file_2.txt"

echo "[OK] Все файлы успешно созданы."
exit $EXIT_SUCCESS