cmd_curl() {
  cmd_gum_spin \
    "Sending HTTP request..." \
    curl --silent --user-agent "$USER_AGENT" \
    "$@"
}

cmd_gum_spin() {
  local message="$1"
  shift
  local command=("$@")

  gum spin \
    --title "$message" \
    --spinner points \
    --show-output \
    -- "${command[@]}"
}

cmd_copy_to_clipboard() {
  # NOTE: I don't want to list xclip/pbcopy as mandatory dependencies.
  if command -v xclip &> /dev/null; then
    echo -n "$@" | xclip -selection clipboard
  elif command -v pbcopy &> /dev/null; then
    echo -n "$@" | pbcopy
  else
    echo "No clipboard manager found. Copy the text manually." >&2
  fi
}

cmd_open_browser() {
  if command -v open &> /dev/null; then
    open "$1"
  elif command -v xdg-open &> /dev/null; then
    xdg-open "$1"
  else
    echo "Unable to open the browser. Open the URL manually." >&2
  fi
}
