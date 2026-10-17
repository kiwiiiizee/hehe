#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${CF_TOKEN:-}" && -n "${SSH_PASSWORD:-}" ]]; then
  printf 'root:%s\n' "$SSH_PASSWORD" | chpasswd
  ssh-keygen -A
  /usr/sbin/sshd -e
  cloudflared tunnel run --token "$CF_TOKEN" &
  echo "SSH tunnel started; web server uses port ${PORT:-8080}."
else
  echo "SSH tunnel disabled. Set CF_TOKEN and SSH_PASSWORD in the app environment to enable it."
fi

exec node /root/server.js
