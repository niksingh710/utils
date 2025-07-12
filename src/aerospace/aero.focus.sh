#!/usr/bin/env bash

# Keybindings
FOCUS_KEY="enter"
MOVE_KEY="space"  

# Display key help
HEADER="$FOCUS_KEY   - Focus window
$MOVE_KEY   - Move window to current workspace
"

# FZF with key capture
window_output="$(aerospace list-windows --all | fzf \
    --prompt='Select a window: ' \
    --header="$HEADER" \
    --header-first \
    --expect="$FOCUS_KEY,$MOVE_KEY" \
)"

# Parse key and selection
key=$(echo "$window_output" | head -n1)
selection=$(echo "$window_output" | tail -n +2)

if [ -z "$selection" ]; then
  echo "No window selected."
  exit 1
fi

# Extract window ID
window_id="$(echo "$selection" | cut -d'|' -f1 | tr -cd '[:digit:]')"

# Perform action based on key
case "$key" in
  "$FOCUS_KEY")
    aerospace focus --window-id "$window_id"
    ;;
  "$MOVE_KEY")
    current_workspace="$(aerospace list-workspaces --focused)"
    aerospace move-node-to-workspace \
      --focus-follows-window \
      --fail-if-noop \
      --window-id "$window_id" \
      "$current_workspace" || aerospace focus --window-id "$window_id"
    ;;
  *)
    echo "Unhandled key: $key"
    ;;
esac
