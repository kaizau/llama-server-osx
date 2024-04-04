# - Use $HOME instead of ~/, since all usage of this variable is quoted

# The `server` script at the root of your llama.cpp repo
LLAMA_SERVER_SCRIPT="$HOME/path/to/llama.cpp/server"

# All *.gguf and *.model.sh files will be displayed in a submenu
LLAMA_SERVER_MODELS=(
  "$HOME/path/to/models"
  "$HOME/path/to/more/models"
)

# Optional server options
# - https://github.com/ggerganov/llama.cpp/blob/master/examples/server/README.md
# - Avoid --model, since it's set by your menu bar selection
#LLAMA_SERVER_OPTIONS=(
#  --host 127.0.0.1
#  --port 8080
#  --ctx-size 4096
#  --n-predict 2048
#  --n-gpu-layers 100
#  --mlock
#  --log-format text
#)

# Optional MacOS sandbox config
# - https://www.karltarvas.com/macos-app-sandboxing-via-sandbox-exec.html
# - https://mybyways.com/blog/run-code-in-a-macos-sandbox
# - https://reverse.put.as/wp-content/uploads/2011/09/Apple-Sandbox-Guide-v1.0.pdf
#LLAMA_SERVER_SANDBOX="$HOME/path/to/sandbox/config"
