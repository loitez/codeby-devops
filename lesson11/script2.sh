#!/bin/bash
# Скрипт управления файлами: подсчёт, права, очистка
# Версия: 1.1

# Константы
readonly FOLDER_NAME="my_folder"
readonly FILE_PERMISSIONS="664"
readonly TARGET_DIR="$HOME/$FOLDER_NAME"
readonly TARGET_FILE="$TARGET_DIR/empty_file_rights.txt"

readonly EXIT_SUCCESS=0
readonly EXIT_FAILURE=1

# 1. Проверка директории
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "[ERROR] Директория не найдена: $TARGET_DIR" >&2
    exit $EXIT_FAILURE
fi

echo "[OK] Директория найдена: $TARGET_DIR"

# 2. Подсчет файлов
file_count=$(find "$TARGET_DIR" -type f | wc -l)
echo "[INFO] Файлов в директории: $file_count"

# 3. Установка прав на файл
if [[ -f "$TARGET_FILE" ]]; then
    if chmod "$FILE_PERMISSIONS" "$TARGET_FILE"; then
        echo "[OK] Права $FILE_PERMISSIONS установлены для: $TARGET_FILE"
    else
        echo "[ERROR] Не удалось изменить права: $TARGET_FILE" >&2
    fi
else
    echo "[WARN] Файл не найден: $TARGET_FILE"
fi

# 4. Удаление пустых файлов
deleted_count=$(find "$TARGET_DIR" -type f -empty -delete -print | wc -l)
echo "[OK] Удалено пустых файлов: $deleted_count"

# 5. Очистка файлов
cleaned_count=0
for file in "$TARGET_DIR"/*; do
    if [[ -f "$file" ]]; then
        # Создаём временный файл для совместимости (Linux/macOS)
        if sed '2,$d' "$file" > "$file.tmp" && mv "$file.tmp" "$file"; then
            ((cleaned_count++))
        else
            echo "[ERROR] Ошибка обработки: $file" >&2
            rm -f "$file.tmp"
        fi
    fi
done

echo "[OK] Обработано файлов: $cleaned_count"
echo "[OK] Скрипт завершён успешно"
exit $EXIT_SUCCESS