#!/bin/bash

# HTTP Proxy Wrapper
# by Lutfa Ilham
# v1.0

if [ "$(id -u)" != "0" ]; then
  echo "Script ini harus user root!" 1>&2
  exit 1
fi

SERVICE_NAME="HTTP Proxy"
SYSTEM_CONFIG="${LIBERNET_DIR}/system/config.json"
SSH_PROFILE="$(grep 'ssh":' ${SYSTEM_CONFIG}  | awk '{print $2}' | sed 's/,//g; s/"//g')"
SSH_CONFIG="${LIBERNET_DIR}/bin/config/ssh/${SSH_PROFILE}.json"
LISTEN_PORT="$(grep 'port":' ${SSH_CONFIG} | awk '{print $2}' | sed 's/,//g; s/"//g' | sed -n '3p')"

function run() {
  # write to service log
  "${LIBERNET_DIR}/bin/log.sh" -w "Memulai layanan ${SERVICE_NAME} ..."
  echo -e "Memulai layanan ${SERVICE_NAME} ..."
  screen -AmdS http-proxy bash -c "while true; do python3 -u \"${LIBERNET_DIR}/bin/http.py\" \"${SSH_CONFIG}\" -l ${LISTEN_PORT}; sleep 3; done" \
    && echo -e "layanan ${SERVICE_NAME} telah dimulai!"
}

function stop() {
  # write to service log
  "${LIBERNET_DIR}/bin/log.sh" -w "Menghentikan layanan ${SERVICE_NAME}"
  echo -e "Menghentikan layanan ${SERVICE_NAME}"
  kill $(screen -list | grep http-proxy | awk -F '[.]' {'print $1'})
  killall python3
  echo -e "layanan ${SERVICE_NAME} telah berhenti!"
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
  *)
    usage
    ;;
esac
