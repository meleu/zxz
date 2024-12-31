list_command() {
  local url

  if [[ "${ARGS['--copy-url']}" == 1 ]]; then
    url="$(pick_url_from_log)" \
      && copy_to_clipboard "$url" \
      && echo "Copied to clipboard: $url" >&2
    return
  fi

  if [[ "${ARGS['--browser']}" == 1 ]]; then
    url="$(pick_url_from_log)" && open_browser "$url"
    return
  fi

  [[ "${ARGS['--update']}" == 1 ]] && update_log_file

  print_uploaded_files
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
