We’ll do vim (vi) + sudo-rs, then safely enable the wheel group.

⸻

The goal (translated to shell logic)
	1.	Install packages:
	•	vim
	•	sudo-rs
	2.	Enable sudo for users in wheel
	3.	Do it non-interactively
	4.	Do it without breaking /etc/sudoers

⸻

The correct way (do NOT open visudo in a script)

visudo is interactive by design.
Scripts should edit /etc/sudoers.d/ instead.

This is the Arch-approved, non-footgun method.

⸻

Example script: setup-sudo.sh

#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing vim and sudo-rs"

pacman -S --noconfirm vim sudo-rs

# -----------------------------
# Enable wheel group for sudo
# -----------------------------
echo "==> Enabling sudo for wheel group"

SUDO_WHEEL_FILE="/etc/sudoers.d/00-wheel"

if [[ ! -f "$SUDO_WHEEL_FILE" ]]; then
  echo "%wheel ALL=(ALL:ALL) ALL" > "$SUDO_WHEEL_FILE"
  chmod 0440 "$SUDO_WHEEL_FILE"
else
  echo "==> Wheel sudo rule already exists, skipping"
fi

# -----------------------------
# Sanity check
# -----------------------------
echo "==> Validating sudo configuration"

visudo -cf /etc/sudoers
visudo -cf "$SUDO_WHEEL_FILE"

echo "==> Done. Users in the wheel group now have sudo."

Make it executable:

chmod +x setup-sudo.sh

Run as root (inside chroot or normal system):

./setup-sudo.sh


⸻

Why this is the right way

❌ Don’t script visudo
	•	It’s interactive
	•	It locks the file
	•	It’s meant for humans, not automation

✅ Use /etc/sudoers.d/
	•	Designed for automation
	•	Safer than editing /etc/sudoers
	•	Modular
	•	Easy to revert

Arch, Debian, Red Hat—all agree on this pattern.

⸻

But what if you really want to uncomment the wheel line?

You can do it, but it’s riskier. For completeness, here’s how it looks:

sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
visudo -cf /etc/sudoers

This works only if:
	•	the line exists
	•	it matches exactly
	•	nothing else changes

That’s why the /etc/sudoers.d/ method is superior.

⸻

One extra pro tip (very Arch)

After this, remember to add your user to wheel:

usermod -aG wheel yourusername

Then log out and back in (or reboot).

⸻

Mental model to keep
	•	Package install → pacman
	•	Privilege policy → /etc/sudoers.d/
	•	Validation → visudo -c
	•	Never edit sudoers blindly

This script is exactly the kind of thing that belongs in your arch-kit repo and will never betray you.

If you want next:
	•	add user creation + wheel membership
	•	make it idempotent across reinstalls
	•	add a --check mode
	•	or adapt it for doas instead of sudo

You’re doing this the right way.