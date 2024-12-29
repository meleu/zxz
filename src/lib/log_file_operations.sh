log_uploaded_file() {
  local header_file="$1"
  local file="$2"
  local url="$3"

  already_logged "$file" "$url" && return

  local token
  local expiration_ms
  local expiration_seconds
  local expiration_time
  local date_format="%Y-%m-%d %H:%M:%S %z"

  token="$(get_header_value "$header_file" "X-Token")"
  [[ -z "$token" ]] && echo "[warning] Unable to get the X-Token for this file." >&2

  expiration_ms="$(get_header_value "$header_file" "X-Expires")"

  expiration_seconds="$((expiration_ms / 1000))"
  expiration_time="$(date -d "@$expiration_seconds" +"$date_format")"
  uploaded_at="$(date +"$date_format")"

  echo "${file};${url};${token};${uploaded_at};${expiration_time}" >> "$LOG_FILE"
}

already_logged() {
  local file="$1"
  local url="$2"
  grep -qF "${file};${url}" "$LOG_FILE"
}

remove_url_from_log() {
  local url="$1"
  # shellcheck disable=2155
  local temp_file="$(mktemp)"

  grep -vF ";${url};" "$LOG_FILE" > "$temp_file" \
    && mv -f "$temp_file" "$LOG_FILE"
}

print_uploaded_files() {
  pick_log_line --print
}

# Show the following information about uploaded files:
# - filename
# - url
# - uploaded_at
# Arguments given to this function are passed to `gum table`
pick_log_line() {
  # CSV format is:
  # filename; url; token; uploaded_at; expiration_time
  cut -d';' -f1-2,4 "$LOG_FILE" \
    | gum table \
      --separator=';' \
      --height 10 \
      --border=rounded \
      --widths=20,48,25 \
      "$@"
}

pick_url_from_log() {
  local log_line

  log_line="$(pick_log_line)"
  if [[ -z $log_line ]]; then
    echo "selection aborted" >&2
    return 1
  fi
  cut -d';' -f2 <<< "$log_line"
}

get_url_token_from_log() {
  local url="$1"
  grep -F ";$url;" "$LOG_FILE" | cut -d';' -f3
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
