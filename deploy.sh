#!/bin/bash

REPO_URL="https://raw.githubusercontent.com/informaten/ssh/main/keys/"

KEYS=(
  "luca.pub"
  "max.pub"
  "alec.pub"
)

LOCAL_USER=$(whoami)
USER_HOME=$(getent passwd "$LOCAL_USER" | cut -d: -f6)
AUTHORIZED_KEYS="${USER_HOME}/.ssh/authorized_keys"
mkdir -p "${USER_HOME}/.ssh"
touch "${AUTHORIZED_KEYS}"


for KEY in "${KEYS[@]}"; do
  KEY_URL="${REPO_URL}${KEY}"
  echo "Adding key from ${KEY_URL}"
  PUBLIC_KEY=$(curl -s "${KEY_URL}")

  if grep -qF "${PUBLIC_KEY}" "${AUTHORIZED_KEYS}"; then
    echo "Key already exists"
    exit 0
  fi

  chown "${LOCAL_USER}":"${LOCAL_USER}" "${AUTHORIZED_KEYS}"
  chmod 600 "${AUTHORIZED_KEYS}"

  echo "Key added to ${AUTHORIZED_KEYS}"

done

