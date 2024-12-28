upload_file() {
  local file="${ARGS[file]}"
  local host="${ARGS[--server]}"
  local uploaded_file_url
  # shellcheck disable=2155
  local response_header_file="$(mktemp)"
  local curl_args=(
    --silent
    --user-agent "$USER_AGENT"
    --dump-header "$response_header_file"
    --form "file=@$file"
  )

  [[ "${ARGS[--secret]}" = 1 ]] && curl_args+=(--form secret=)

  uploaded_file_url="$(curl "${curl_args[@]}" "$host")"
  echo "$uploaded_file_url"

  log_uploaded_file "$response_header_file" "$file" "$uploaded_file_url"
  rm -f "$response_header_file"
}
