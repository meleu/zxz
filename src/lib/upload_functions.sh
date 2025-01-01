upload_command() {
  [[ -z "$1" ]] && return 1

  local file="$1"
  local host="$2"
  local is_secret="${ARGS[--secret]}"
  local retention_hours="${ARGS['--retention-hours']}"

  # shellcheck disable=2155
  local response_header_file="$(mktemp)"
  local curl_args=(
    --dump-header "$response_header_file"
    --form "file=@$file"
  )
  local uploaded_file_url

  [[ "$is_secret" == 1 ]] && curl_args+=(--form secret=)
  [[ "$retention_hours" -gt 0 ]] && curl_args+=(--form expires="$retention_hours")

  uploaded_file_url="$(cmd_curl "${curl_args[@]}" "$host")"
  if [[ -z "$uploaded_file_url" ]]; then
    echo "Failed to upload file: $file" >&2
    return 1
  fi

  echo "$uploaded_file_url"
  [[ "${ARGS['--copy-url']}" == 1 ]] && cmd_copy_to_clipboard "$uploaded_file_url"

  log_uploaded_file "$response_header_file" "$file" "$uploaded_file_url"
  rm -f "$response_header_file"
}
