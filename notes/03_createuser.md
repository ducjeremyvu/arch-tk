Below is a safe, idempotent, chroot-friendly script that:
	•	creates a user
	•	creates a home directory
	•	sets the shell
	•	adds the user to wheel
	•	does not break if you run it twice
	•	prompts for a password (securely)

This is exactly the kind of thing you want in your Arch toolkit.

⸻

Example: create-user.sh

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

Make it executable:

chmod +x create-user.sh

Run it as root:

./create-user.sh jeremy


⸻

Why this script is correct
	•	Uses useradd (low-level, predictable)
	•	Explicit flags (no defaults guessing)
	•	Checks if user already exists
	•	Does not assume sudo works yet
	•	Prompts for password securely
	•	Safe in chroot and on live systems

⸻

Optional upgrades (when you’re ready)

Use zsh instead of bash

Change:

--shell /bin/bash

to:

--shell /bin/zsh

(And make sure zsh is installed.)

⸻

Auto-create SSH directory

install -d -m 700 -o "$USERNAME" -g "$USERNAME" "/home/$USERNAME/.ssh"


⸻

Non-interactive password (not recommended)

Only for CI or throwaway VMs:

echo "$USERNAME:password" | chpasswd


⸻

Mental model
	•	useradd = structure
	•	passwd = secrets
	•	wheel = power
	•	scripting this = never locking yourself out again

This script pairs perfectly with your sudo setup script.

If you want next, we can:
	•	merge user creation + sudo setup
	•	add multiple users from a config file
	•	add SSH key injection
	•	or make a full “first boot” script that gets you from chroot → usable system in one go

You’re building a system that remembers how to rebuild itself.