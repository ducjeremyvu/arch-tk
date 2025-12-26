#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Configuration
# -----------------------------
USERNAME="${1:-}"

if [[ -z "$USERNAME" ]]; then
  echo "Usage: $0 <username>"
  exit 1
fi

echo "==> Creating user: $USERNAME"

# -----------------------------
# Create user (if missing)
# -----------------------------
if id "$USERNAME" &>/dev/null; then
  echo "==> User '$USERNAME' already exists, skipping creation"
else
  useradd \
    --create-home \
    --shell /bin/bash \
    --groups wheel \
    "$USERNAME"

  echo "==> User '$USERNAME' created"
fi

# -----------------------------
# Set password
# -----------------------------
echo "==> Set password for $USERNAME"
passwd "$USERNAME"

# -----------------------------
# Ensure home permissions
# -----------------------------
HOME_DIR="/home/$USERNAME"

if [[ -d "$HOME_DIR" ]]; then
  chown -R "$USERNAME:$USERNAME" "$HOME_DIR"
fi

# -----------------------------
# Summary
# -----------------------------
echo "==> User '$USERNAME' is ready"
echo "    - Home: $HOME_DIR"
echo "    - Groups: wheel"
echo "    - Shell: /bin/bash"