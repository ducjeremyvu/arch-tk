#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing paru (AUR helper)"

# 1. Ensure required packages are installed
echo "==> Installing base-devel and git"
sudo pacman -S --needed --noconfirm base-devel git

# 2. Create temp dir
WORKDIR="$(mktemp -d)"
echo "==> Working in $WORKDIR"
cd "$WORKDIR"

# 3. Clone paru
echo "==> Cloning paru"
git clone https://aur.archlinux.org/paru.git
cd paru

# 4. Build and install
echo "==> Building and installing paru"
makepkg -si --noconfirm

# 5. Cleanup
echo "==> Cleaning up"
cd /
rm -rf "$WORKDIR"

# 6. Verify
echo "==> Verifying installation"
paru --version

echo "✅ paru installed successfully"
