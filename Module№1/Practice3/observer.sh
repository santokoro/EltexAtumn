#!/bin/bash

CONF_FILE="observer.conf"
LOG_FILE="observer.log"

if [ ! -f "$CONF_FILE" ]; then
    echo "Ошибка: файл конфигурации $CONF_FILE не найден"
    exit 1
fi

while IFS= read -r script_path || [ -n "$script_path" ]; do
    [ -z "$script_path" ] && continue
    [[ "$script_path" == \#* ]] && continue

    is_running=0
    for pid_dir in /proc/[0-9]*; do
        if [ -r "$pid_dir/cmdline" ]; then
            if tr '\0' ' ' < "$pid_dir/cmdline" | grep -q "$script_path"; then
                is_running=1
                break
            fi
        fi
    done

    if [ "$is_running" -eq 0 ]; then
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        echo "$TIMESTAMP Запуск $script_path" >> "$LOG_FILE"
        nohup "$script_path" > /dev/null 2>&1 &
    fi
done < "$CONF_FILE"
