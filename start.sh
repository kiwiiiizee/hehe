#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${SSH_PASSWORD:-}" ]]; then
  printf 'root:%s\n' "$SSH_PASSWORD" | chpasswd
  ssh-keygen -A
  /usr/sbin/sshd -e

  (
    while true; do
      echo "Opening temporary Pinggy TCP tunnel to SSH on port 22..."
      if ssh -p 443 \
        -T \
        -o ExitOnForwardFailure=yes \
        -o ServerAliveInterval=30 \
        -o ServerAliveCountMax=3 \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -R0:127.0.0.1:22 \
        tcp@free.pinggy.io; then
        echo "Pinggy tunnel closed; reconnecting in 10 seconds."
      else
        echo "Pinggy tunnel disconnected; reconnecting in 10 seconds."
      fi
      sleep 10
    done
  ) &

  echo "SSH tunnel enabled; web server uses port ${PORT:-8080}."
else
  echo "SSH tunnel disabled. Set SSH_PASSWORD in the app environment to enable it."
fi

exec node /root/server.js
