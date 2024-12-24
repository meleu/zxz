upload_file() {
  local curl_args=(
    --user-agent "${user_agent}"
    "--form file=@${args[file]}"
  )

  [[ "${args[--secret]}" = 1 ]] && curl_args+=("--form secret=")

  curl "${curl_args[@]}" "https://0x0.st/"
}
