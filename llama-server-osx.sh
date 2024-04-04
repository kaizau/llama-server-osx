#!/bin/bash

#
# Llama Server OSX
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
  cp "$app_dir/options.sh" "$config_dir"
  cp "$app_dir/example.model.sh" "$config_dir"
  cp "$app_dir/example.sandbox.sb" "$config_dir"
  open "$config_dir"
  exit 0
elif [ "$1" == "Edit ~/.config/llamaserver" ]; then
  open "$config_dir"
  exit 0
fi

if [ ! -f "$config_options" ]; then
  echo "Create ~/.config/llamaserver"
  exit 0
fi

source "$config_options"

if [[ "$LLAMA_SERVER_SCRIPT" == *"/path/to/llama.cpp/server" ]] || [[ ${#LLAMA_SERVER_MODELS[@]} -eq 0 ]]; then
  echo "Edit ~/.config/llamaserver"
  exit 0
fi

#
# Models
#

all_models=()

shopt -s nullglob
for dir in "${LLAMA_SERVER_MODELS[@]}"; do
  for file in "$dir"/*.{gguf,model.sh}; do
    all_models+=("$file")
  done
done
shopt -u nullglob

if [ ${#all_models[@]} -eq 0 ]; then
  echo "Edit ~/.config/llamaserver"
  exit 0
fi

model_resolve() {
  base=$1
  for file in "${all_models[@]}"; do
    if [ "$(basename "$file")" == "$base" ]; then
      echo "$file"
      return
    fi
  done
}

model_menu() {
  for file in "${all_models[@]}"; do
    echo "$(basename "$file")"
  done | sort -V | paste -sd "|" -
}

#
# Commands
#

log_file="$config_dir/server.log"
server_options=("${LLAMA_SERVER_OPTIONS[@]}");

start_server() {
  if [ -f "$LLAMA_SERVER_SANDBOX" ]; then
    echo "sandbox-exec -f $LLAMA_SERVER_SANDBOX nohup $LLAMA_SERVER_SCRIPT ${server_options[@]}" >> "$log_file"
    sandbox-exec -f "$LLAMA_SERVER_SANDBOX" nohup "$LLAMA_SERVER_SCRIPT" "${server_options[@]}" >> "$log_file" 2>&1 &
  else
    echo "nohup $LLAMA_SERVER_SCRIPT ${server_options[@]}" >> "$log_file"
    nohup "$LLAMA_SERVER_SCRIPT" "${server_options[@]}" >> "$log_file" 2>&1 &
  fi
}

# Command: Select model
if [[ "$1" == *.gguf ]]; then
  echo "$1" > "$log_file"
  server_options+=("--model $(model_resolve "$1")")
  start_server

# Command: Select configured model
elif [[ "$1" == *.model.sh ]]; then
  echo "$1" > "$log_file"
  source $(model_resolve "$1")
  server_options+=("${LLAMA_SERVER_MODEL_OPTIONS[@]}")
  start_server

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
  if [ -f "$log_file" ]; then
    echo "DISABLED|Using: $(head -n 1 "$log_file")"
    echo "----"
    tail -n 5 "$log_file" | tr -s ' ' | fold -w 50 | sed 's/^/DISABLED|/'
  fi

# Or not running
else
  echo "STATUSTITLE|🦙"
  echo "SUBMENU|Load model|$(model_menu)"
  echo "Edit ~/.config/llamaserver"
fi