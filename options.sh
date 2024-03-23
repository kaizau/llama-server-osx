# The `server` script at the root of your llama.cpp repo
LLAMA_SERVER_SCRIPT="~/path/to/llama.cpp/server"

# All *.gguf and *.model.sh files will be displayed in a submenu
LLAMA_SERVER_MODELS="~/path/to/models"

# Server options (except --model)
# https://github.com/ggerganov/llama.cpp/blob/master/examples/server/README.md
LLAMA_SERVER_OPTIONS=(
  --host 127.0.0.1
  --port 8080
  --ctx-size 4096
  --n-gpu-layers 80
  --mlock
)