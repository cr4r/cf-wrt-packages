#!/bin/bash

# Trojan Wrapper
# by Lutfa Ilham
# v1.0

if [ "$(id -u)" != "0" ]; then
  echo "Script ini harus user root!" 1>&2
  exit 1
fi

SERVICE_NAME="Trojan"
SYSTEM_CONFIG="${LIBERNET_DIR}/system/config.json"
TROJAN_PROFILE="$(grep 'trojan":' ${SYSTEM_CONFIG} | awk '{print $2}' | sed 's/,//g; s/"//g')"
TROJAN_CONFIG="${LIBERNET_DIR}/bin/config/trojan/${TROJAN_PROFILE}.json"

function run() {
  # write to service log
  "${LIBERNET_DIR}/bin/log.sh" -w "Config: ${TROJAN_PROFILE}, Mode: ${SERVICE_NAME}"
  "${LIBERNET_DIR}/bin/log.sh" -w "Memulai layanan ${SERVICE_NAME}"
  echo -e "Memulai layanan ${SERVICE_NAME}"
  screen -AmdS trojan-client bash -c "while true; do trojan-go -config \"${TROJAN_CONFIG}\"; sleep 3; done" \
    && echo -e "Layanan ${SERVICE_NAME} dimulai!"
}

function stop() {
  # write to service log
  "${LIBERNET_DIR}/bin/log.sh" -w "Menghentikan layanan ${SERVICE_NAME}"
  echo -e "Menghentikan layanan ${SERVICE_NAME} ..."
  kill $(screen -list | grep trojan-client | awk -F '[.]' {'print $1'})
  killall trojan-go
  echo -e "${SERVICE_NAME} service stopped!"
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
