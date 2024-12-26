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

log_uploaded_file() {
  local header_file="$1"
  local file="$2"
  local url="$3"
  # if this file was already uploaded to the same URL, no need to log it again
  grep -qF "${file};${url}" "$LOG_FILE" && return

  local token
  local expiration_ms
  local expiration_seconds
  local expiration_time
  local date_format="%Y-%m-%d %H:%M:%S %z"

  token="$(get_header_value "$header_file" "X-Token")"
  expiration_ms="$(get_header_value "$header_file" "X-Expires")"

  expiration_seconds="$((expiration_ms / 1000))"
  expiration_time="$(date -d "@$expiration_seconds" +"$date_format")"
  uploaded_at="$(date +"$date_format")"

  echo "${file};${url};${token};${uploaded_at};${expiration_time}" >> "$LOG_FILE"
}

get_header_value() {
  local file="$1"
  local header_name="$2"
  local header_value
  local line

  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" != "${header_name}: "* ]] && continue
    header_value="${line#"$header_name: "}"
    header_value="${header_value%$'\r'}" # remove trailing '\r'
  done < "$file"

  echo "$header_value"
}
