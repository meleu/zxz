delete_command() {
  local chosen_url
  local token

  printf "\nChoose the file to be deleted:\n\n"

  # get the url and the token
  chosen_url="$(pick_url_from_log)" || return $?
  token="$(get_url_token_from_log "${chosen_url}")"
  if [[ -z "$token" ]]; then
    echo "[error] Unable to get the X-Token for $chosen_url"
    return 1
  fi

  cmd_curl \
    --output /dev/null \
    --form token="$token" \
    --form delete= \
    "$chosen_url"

  confirm_url_available "$chosen_url" \
    || remove_url_from_log "$chosen_url"
}

confirm_url_available() {
  local url="$1"
  local response_status

  response_status="$(url_http_status "$url")"

  case "$response_status" in
    200)
      echo "- <$url>: is still available." >&2
      return 0
      ;;
    404)
      echo "- <$url>: resource not found in the server (HTTP status ${response_status})." >&2
      ;;
    '')
      echo "- <$url>: failed to get the HTTP status." >&2
      ;;
    *)
      echo "- <$url>: returned HTTP status ${response_status}." >&2
      ;;
  esac

  return 1
}

# Returns true if a request to the given URL returns 404 HTTP status,
# otherwise returns false.
url_http_status() {
  local url="$1"

  # getting only the headers and getting the http status code
  cmd_curl --head "$url" \
    | head -1 \
    | cut -d' ' -f2
}
