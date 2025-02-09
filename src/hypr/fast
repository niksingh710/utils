#!/usr/bin/env bash
# Meant to be used on Hyprland
# with nix dependencies should be managed
state=$(hyprctl getoption animations:enabled -j | jq .int)

if [ "$state" -eq 0 ]; then
  hyprctl reload
else
  hyprctl keyword animations:enabled 0
  hyprctl keyword decoration:rounding 0
fi
