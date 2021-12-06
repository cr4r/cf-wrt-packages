#!/bin/bash

# PING Loop Wrapper
# by Lutfa Ilham
# v1.0

if [ "$(id -u)" != "0" ]; then
  echo "Script ini harus user root!" 1>&2
  exit 1
fi

SERVICE_NAME="PING loop"
SYSTEM_CONFIG="${LIBERNET_DIR}/system/config.json"
INTERVAL="3"
HOST="bing.com"

function http_ping() {
  httping -qi "${INTERVAL}" -t "${INTERVAL}" "${HOST}"
}

function loop() {
  while true; do
    http_ping
    sleep $INTERVAL
  done
}

function run() {
  # write to service log
  "${LIBERNET_DIR}/bin/log.sh" -w "Memulai layanan ${SERVICE_NAME}"
  echo -e "Memulai layanan ${SERVICE_NAME} ..."
  screen -AmdS ping-loop "${LIBERNET_DIR}/bin/ping-loop.sh" -l \
    && echo -e "Layanan ${SERVICE_NAME} dimulai!"
}

function stop() {
  # write to service log
  "${LIBERNET_DIR}/bin/log.sh" -w "Menghentikan layanan ${SERVICE_NAME}"
  echo -e "Menghentikan layanan ${SERVICE_NAME} ..."
  kill $(screen -list | grep ping-loop | awk -F '[.]' {'print $1'}) > /dev/null 2>&1
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
