FOLDER="my_folder"
TARGET_DIR="$HOME/$FOLDER"
TARGET_FILE="$TARGET_DIR/empty_file_rights.txt"

if [ -d "$TARGET_DIR" ]; then
    FILE_COUNT=$(find "$TARGET_DIR" -type f | wc -l)
    echo "Количество файлов в $TARGET_DIR: $FILE_COUNT"
else
    echo "Ошибка: Директория $TARGET_DIR не найдена."
    return
fi

if [ -f "$TARGET_FILE" ]; then
  chmod 664 "$TARGET_FILE"
else
    echo "Файл $FILE не найден."
fi

find "$TARGET_DIR" -type f -empty -delete

for file in "$TARGET_DIR"/*; do
    if [ -f "$file" ]; then
        sed -i '2,$d' "$file"
    fi
done