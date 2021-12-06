#!/bin/bash

# Memory Cleaner Wrapper
# by Lutfa Ilham
# v1.0

if [ "$(id -u)" != "0" ]; then
  echo "Script ini harus user root!" 1>&2
  exit 1
fi

SERVICE_NAME="Memory Cleaner"
SYSTEM_CONFIG="${LIBERNET_DIR}/system/config.json"
INTERVAL="1h"

function clear_memory() {
  clear \
    && sync \
    && echo -e "Sebelum memori digunakan:" \
    && free \
    && echo -e "" \
    && echo -e "Membersihkan Memori ..." \
    && echo 3 > /proc/sys/vm/drop_caches \
    && echo -e "Selesai!\n" \
    && echo -e "Setelah memori digunakan:" \
    && free
}

function loop() {
  while true; do
    clear_memory
    sleep "${INTERVAL}"
  done
}

function run() {
  # write to service log
  "${LIBERNET_DIR}/bin/log.sh" -w "Memulai layanan ${SERVICE_NAME}"
  echo -e "Memulai layanan ${SERVICE_NAME}"
  screen -AmdS memory-cleaner "${LIBERNET_DIR}/bin/memory-cleaner.sh" -l \
    && echo -e "Layanan ${SERVICE_NAME} dimulai!"
}

function stop() {
  # write to service log
  "${LIBERNET_DIR}/bin/log.sh" -w "Menghentikan layanan ${SERVICE_NAME}"
  echo -e "Menghentikan layanan ${SERVICE_NAME} ..."
  kill $(screen -list | grep memory-cleaner | awk -F '[.]' {'print $1'})
  echo -e "Layanan ${SERVICE_NAME} berhenti!"
}

function usage() {
  cat <<EOF
Usage:
  -r  Run ${SERVICE_NAME} service
  -s  Stop ${SERVICE_NAME} service
EOF
}

case "${1}" in
  -r)
    run
    ;;
  -s)
    stop
    ;;
  -l)
    loop
    ;;
  *)
    usage
    ;;
esac
