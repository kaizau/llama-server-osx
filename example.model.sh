# Copy this file into your $LLAMA_SERVER_MODELS folder, set model-specific
# overrides, then select this script in the submenu.
LLAMA_SERVER_MODEL_OPTIONS=(
  --model ~/path/to/guff
  --ctx-size 16384
	--chat-template chatml
)