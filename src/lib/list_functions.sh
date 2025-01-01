pick_and_copy_url() {
  local url
  url="$(pick_url_from_log)" \
    && cmd_copy_to_clipboard "$url" \
    && echo "Copied to clipboard: $url" >&2
}

pick_and_open_url() {
  local url
  url="$(pick_url_from_log)" && cmd_open_browser "$url"
}
