upload_file() {
  local curl_args=(
    --user-agent "${USER_AGENT}"
    --form "file=@${ARGS[file]}"
  )
  local host="${ARGS[--server]}"

  [[ "${ARGS[--secret]}" = 1 ]] && curl_args+=(--form secret=)

  set -x
  curl "${curl_args[@]}" "$host"
}
