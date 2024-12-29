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

  "${CURL[@]}" \
    --output /dev/null \
    --form token="$token" \
    --form delete= \
    "$chosen_url"

  confirm_url_not_available "$chosen_url"
  remove_url_from_log "$chosen_url"
}

confirm_url_not_available() {
  local url="$1"
  local response_status

  response_status="$(url_http_status "$url")"

  case "$response_status" in
    404)
      echo "[success] The file was successfully deleted from server."
      return 0
      ;;
    200)
      echo "[fail] The URL is still available."
      ;;
    *)
      echo "[fail] Unable to confirm the deletion (returned HTTP status ${response_status})."
      ;;
  esac

  return 1
}

# Returns true if a request to the given URL returns 404 HTTP status,
# otherwise returns false.
url_http_status() {
  local url="$1"

  # getting only the headers and getting the http status code
  "${CURL[@]}" --head "$url" \
    | head -1 \
    | cut -d' ' -f2
}
