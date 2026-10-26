#!/bin/bash

SCRIPT_NAME=$(basename "$0")

if [ "$SCRIPT_NAME" == "template_task.sh" ]; then
    echo "я бригадир, сам не работаю"
    exit 1
fi

LOG_FILE="report_${SCRIPT_NAME}.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
MY_PID=$$
echo "$TIMESTAMP [$MY_PID] Скрипт запущен" >> "$LOG_FILE"

FIFO_PATH="/tmp/cuckoo_fifo"
RESPONSE_FILE="/tmp/cuckoo_response_${MY_PID}.tmp"

rm -f "$RESPONSE_FILE"

echo "NAME[$MY_PID]: how much time do I have?" > "$FIFO_PATH"

N=""
for i in {1..50}; do
    if [ -f "$RESPONSE_FILE" ]; then
        N=$(cat "$RESPONSE_FILE")
        rm -f "$RESPONSE_FILE"
        break
    fi
    sleep 0.1
done

if [ -z "$N" ]; then
    echo "Ошибка: не удалось получить ответ от cuckoo.sh" >> "$LOG_FILE"
    exit 1
fi

sleep "$N"

TIMESTAMP_END=$(date '+%Y-%m-%d %H:%M:%S')
echo "$TIMESTAMP_END [$MY_PID] Скрипт завершился, работал $N секунд." >> "$LOG_FILE"#!/bin/bash

SCRIPT_NAME=$(basename "$0")

if [ "$SCRIPT_NAME" == "template_task.sh" ]; then
    echo "я бригадир, сам не работаю"
    exit 1
fi

LOG_FILE="report_${SCRIPT_NAME}.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
MY_PID=$$
echo "$TIMESTAMP [$MY_PID] Скрипт запущен" >> "$LOG_FILE"

FIFO_PATH="/tmp/cuckoo_fifo"
RESPONSE_FILE="/tmp/cuckoo_response_${MY_PID}.tmp"

rm -f "$RESPONSE_FILE"

echo "NAME[$MY_PID]: how much time do I have?" > "$FIFO_PATH"

N=""
for i in {1..50}; do
    if [ -f "$RESPONSE_FILE" ]; then
        N=$(cat "$RESPONSE_FILE")
        rm -f "$RESPONSE_FILE"
        break
    fi
    sleep 0.1
done

if [ -z "$N" ]; then
    echo "Ошибка: не удалось получить ответ от cuckoo.sh" >> "$LOG_FILE"
    exit 1
fi

sleep "$N"

TIMESTAMP_END=$(date '+%Y-%m-%d %H:%M:%S')
echo "$TIMESTAMP_END [$MY_PID] Скрипт завершился, работал $N секунд." >> "$LOG_FILE"
