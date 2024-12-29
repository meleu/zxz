mkdir -p "$LOG_DIR"

export CURL=(
  gum_spinner "Sending HTTP request..."
  curl --silent --user-agent "$USER_AGENT"
)
