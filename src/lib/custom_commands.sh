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
