#!/usr/bin/env bash

sudo pacman -S --noconfirm \
  mesa \
  libdrm \
  wayland \
  wayland-protocols \
  xorg-xwayland

sudo pacman -S hyprland

sudo pacman -S --noconfirm \
  waybar \
  foot \
  wofi \
  grim \
  slurp \
  wl-clipboard \
  polkit-gnome \
  kitty