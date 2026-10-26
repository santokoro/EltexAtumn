#!/bin/bash

FIFO_PATH=""
LOG_FILE="cuckoo.log"

for arg in "$@"; do
    case $arg in
        --pishitesuda=*)
            FIFO_PATH="${arg#*=}"
            ;;
    esac
done

if [ -z "$FIFO_PATH" ]; then
    echo "Ошибка: не указан путь к именованному каналу (--pishitesuda=/path/to/fifo)"
    exit 1
fi

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

cleanup() {
    log_message "Shutdown!"
    if [ -p "$FIFO_PATH" ]; then
        rm -f "$FIFO_PATH"
    fi
    exit 0
}

trap cleanup SIGTERM SIGINT

if [ ! -p "$FIFO_PATH" ]; then
    mkfifo "$FIFO_PATH"
    chmod 666 "$FIFO_PATH"
fi

log_message "Startup!"

while true; do
    if read -r line < "$FIFO_PATH"; then
        if [[ "$line" =~ ^([^[]+)\[([0-9]+)\]:\ how\ much\ time\ do\ I\ have\?$ ]]; then
            NAME="${BASH_REMATCH[1]}"
            PID="${BASH_REMATCH[2]}"
            N=$((RANDOM % 9 + 2))
            log_message "$NAME[$PID] $N"
            echo "$N" > "/tmp/cuckoo_response_${PID}.tmp"
            chmod 666 "/tmp/cuckoo_response_${PID}.tmp"
        fi
    fi
done
