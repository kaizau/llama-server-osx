#!/bin/bash

#
# Llama Server Menubar
#
# A shell script, in a shell script, in a Platypus wrapper
#

#
# Init / Config
#

config_dir="$HOME/.config/llamaserver"
config_options="$config_dir/options.sh"

if [ "$1" == "Create ~/.config/llamaserver" ]; then
  mkdir -p "$config_dir"
  app_dir=$(dirname "$(readlink -f "$0")")
  cp "$app_dir/options.sh" "$config_options"
  open "$HOME/.config/llamaserver/"
  exit 0
elif [ "$1" == "Edit ~/.config/llamaserver" ]; then
  open "$HOME/.config/llamaserver/"
  exit 0
fi

if [ ! -f "$config_options" ]; then
  echo "Create ~/.config/llamaserver"
  exit 0
fi

source "$config_options"

if [[ "$LLAMA_SERVER_SCRIPT" == *"/path/to/llama.cpp/server" ]] ||
   [[ "$LLAMA_SERVER_MODELS" == *"/path/to/ggufs" ]]; then
  echo "Edit ~/.config/llamaserver"
  exit 0
fi

#
# Commands
#

log_file="$config_dir/server.log"

# Command: Select model
if [[ $1 == *.gguf ]]; then
  echo "$1" > "$log_file"

  nohup "$LLAMA_SERVER_SCRIPT" \
    "${LLAMA_SERVER_OPTIONS[@]}" \
    --model "$LLAMA_SERVER_MODELS/$1" \
    --log-format text >> "$log_file" 2>&1 &

# Command: Stop server
elif [ "$1" == "Stop server" ]; then
  rm "$log_file"
  pkill -f "$LLAMA_SERVER_SCRIPT"
fi

#
# Render menu
#

# Server process is running
if pgrep -f "$LLAMA_SERVER_SCRIPT" > /dev/null; then
  echo "STATUSTITLE|🦙🟢"
  echo "Stop server"
  echo "Edit ~/.config/llamaserver"
  echo "----"
  echo "DISABLED|Using: $(head -n 1 "$log_file")"
  echo "----"
  tail -n 5 "$log_file" | tr -s ' ' | fold -w 50 | sed 's/^/DISABLED|/'

# Or not running
else
  model_menu() {
    for file in "$LLAMA_SERVER_MODELS"/*.gguf; do
      echo "$(basename "$file")"
    done | sort -V | paste -sd "|" -
  }

  echo "STATUSTITLE|🦙"
  echo "SUBMENU|Load model|$(model_menu)"
  echo "Edit ~/.config/llamaserver"
fi