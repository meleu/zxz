upload_command() {
  local file="$1"
  [[ -z "$file" ]] && return 1

  local host="$2"
  local upload_as_secret="$3"
  local uploaded_file_url
  # shellcheck disable=2155
  local response_header_file="$(mktemp)"
  local curl_args=(
    --dump-header "$response_header_file"
    --form "file=@$file"
  )

  [[ "$upload_as_secret" == 1 ]] && curl_args+=(--form secret=)

  uploaded_file_url="$(cmd_curl "${curl_args[@]}" "$host")"
  if [[ -z "$uploaded_file_url" ]]; then
    echo "Failed to upload file: $file" >&2
    return 1
  fi

  echo "$uploaded_file_url"
  log_uploaded_file "$response_header_file" "$file" "$uploaded_file_url"
  rm -f "$response_header_file"
}
