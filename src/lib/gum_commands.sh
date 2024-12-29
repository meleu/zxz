gum_spinner() {
  local message="$1"
  shift
  local command=("$@")

  gum spin \
    --title "$message" \
    --spinner points \
    --show-output \
    -- "${command[@]}"
}
