pick_and_copy_url() {
  local url
  url="$(pick_url_from_log)" \
    && copy_to_clipboard "$url" \
    && echo "Copied to clipboard: $url" >&2
}

pick_and_open_url() {
  local url
  url="$(pick_url_from_log)" && open_browser "$url"
}

open_browser() {
  case "$OSTYPE" in
    darwin*)
      open "$1"
      ;;
    *) # Hopefully Linux
      xdg-open "$1"
      ;;
  esac
}

copy_to_clipboard() {
  case "$OSTYPE" in
    darwin*)
      echo -n "$1" | pbcopy
      ;;
    *) # Hopefully Linux
      echo -n "$1" | xclip -selection clipboard
      ;;
  esac
}
