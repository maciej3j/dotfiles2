#!/usr/bin/env bash

choice="$(
  printf '%s\n' \
    '[L] Lock' \
    '[O] Logout' \
    '[R] Reboot' \
    '[S] Shutdown' \
    '[Z] Suspend' \
  | fuzzel --dmenu --prompt='Power > '
)"

case "$choice" in
  '[L] Lock'|l|L)
    hyprlock
    ;;
  '[O] Logout'|o|O)
    hyprctl dispatch exit
    ;;
  '[R] Reboot'|r|R)
    systemctl reboot
    ;;
  '[S] Shutdown'|s|S)
    systemctl poweroff
    ;;
  '[Z] Suspend'|z|Z)
    systemctl suspend
    ;;
esac
