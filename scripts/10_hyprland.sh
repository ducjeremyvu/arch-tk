#!/usr/bin/env bash

sudo pacman -S \
  mesa \
  libdrm \
  wayland \
  wayland-protocols \
  xorg-xwayland

sudo pacman -S hyprland

sudo pacman -S \
  waybar \
  foot \
  wofi \
  grim \
  slurp \
  wl-clipboard \
  polkit-gnome