FOLDER="my_folder"
TARGET_DIR="$HOME/$FOLDER"

TODAY=$(date "+%Y-%m-%d")

mkdir -p  $HOME/$FOLDER

echo -e "Hello world!\n$TODAY"> "$TARGET_DIR/hello.txt"

touch "$TARGET_DIR/empty_file_rights.txt"

chmod 777 "$TARGET_DIR/empty_file_rights.txt"

</dev/urandom tr -dc 'A-Za-z0-9!@#$%^&*()' | head -c 20 > "$HOME/$FOLDER/random.txt"

touch "$TARGET_DIR"/{empty_file.txt,empty_file_2.txt}

