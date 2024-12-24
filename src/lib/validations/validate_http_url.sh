validate_http_url() {
  local regex_http_url="^https?://[^[:space:]/$.?#].[^[:space:]]*$"
  [[ $1 =~ $regex_http_url ]] || echo "must be a valid http URL"
}
