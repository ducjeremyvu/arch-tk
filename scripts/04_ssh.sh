#!/usr/bin/env bash
set -euo pipefail

USERNAME="${1:-}"

if [[ -z "$USERNAME" ]]; then
  echo "Usage: $0 <username>"
  exit 1
fi

echo "==> Setting up SSH for user: $USERNAME"

# -----------------------------
# Install OpenSSH
# -----------------------------
echo "==> Installing openssh"

pacman -S --noconfirm openssh

# -----------------------------
# Enable SSH daemon
# -----------------------------
echo "==> Enabling sshd"

systemctl enable sshd

# -----------------------------
# SSH hardening
# -----------------------------
SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP="/etc/ssh/sshd_config.bak"

if [[ ! -f "$BACKUP" ]]; then
  cp "$SSHD_CONFIG" "$BACKUP"
fi

echo "==> Hardening sshd_config"

sed -i \
  -e 's/^#\?PermitRootLogin.*/PermitRootLogin no/' \
  -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' \
  -e 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' \
  "$SSHD_CONFIG"

# -----------------------------
# Setup user SSH directory
# -----------------------------
USER_HOME=$(getent passwd "$USERNAME" | cut -d: -f6)
SSH_DIR="$USER_HOME/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"

echo "==> Preparing ~/.ssh for $USERNAME"

install -d -m 700 -o "$USERNAME" -g "$USERNAME" "$SSH_DIR"

if [[ ! -f "$AUTHORIZED_KEYS" ]]; then
  install -m 600 -o "$USERNAME" -g "$USERNAME" /dev/null "$AUTHORIZED_KEYS"
fi

# -----------------------------
# Validate config
# -----------------------------
echo "==> Validating sshd configuration"
sshd -t

echo "==> SSH setup complete"
echo "    - Root login: disabled"
echo "    - Password auth: disabled"
echo "    - Key auth: enabled"
echo
echo "IMPORTANT:"
echo "  Add your public key to:"
echo "  $AUTHORIZED_KEYS"