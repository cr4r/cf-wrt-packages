#!/bin/bash

# V2Ray Wrapper
# by Lutfa Ilham
# v1.0

if [ "$(id -u)" != "0" ]; then
  echo "Script ini harus user root!" 1>&2
  exit 1
fi

SERVICE_NAME="V2Ray"
SYSTEM_CONFIG="${LIBERNET_DIR}/system/config.json"
V2RAY_PROFILE="$(grep 'v2ray":' ${SYSTEM_CONFIG} | awk '{print $2}' | sed 's/,//g; s/"//g')"
V2RAY_CONFIG="${LIBERNET_DIR}/bin/config/v2ray/${V2RAY_PROFILE}.json"
V2RAY_PROTOCOL="$(grep 'protocol":' ${V2RAY_CONFIG} | awk '{print $2}' | sed 's/,//g; s/"//g' | tail -n1)"

function run() {
  case "${V2RAY_PROTOCOL}" in
    "vmess")
      V2RAY_PROTOCOL="VMess"
      ;;
    "vless")
      V2RAY_PROTOCOL="VLESS"
      ;;
    "trojan")
      V2RAY_PROTOCOL="Trojan"
      ;;
  esac
  # write to service log
  "${LIBERNET_DIR}/bin/log.sh" -w "Config: ${V2RAY_PROFILE}, Mode: ${SERVICE_NAME}, Protocol: ${V2RAY_PROTOCOL}"
  "${LIBERNET_DIR}/bin/log.sh" -w "Starting ${SERVICE_NAME} service"
  echo -e "Memulai layanan ${SERVICE_NAME} ..."
  screen -AmdS v2ray-client bash -c "while true; do v2ray -c \"${V2RAY_CONFIG}\"; sleep 3; done" \
    && echo -e "Layanan ${SERVICE_NAME} dimulai!"
}

function stop() {
  # write to service log
  "${LIBERNET_DIR}/bin/log.sh" -w "Menghentikan layanan ${SERVICE_NAME}"
  echo -e "Menghentikan layanan ${SERVICE_NAME} ..."
  kill $(screen -list | grep v2ray-client | awk -F '[.]' {'print $1'})
  killall v2ray
  echo -e "Layanan ${SERVICE_NAME} dihentikan!"
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
