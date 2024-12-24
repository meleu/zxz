upload_file() {
  local curl_args=(
    "-Ffile=@${args[file]}"
  )

  [[ "${args[--secret]}" = 1 ]] && curl_args+=("-Fsecret=")

  curl "${curl_args[@]}" "https://0x0.st/"
}
