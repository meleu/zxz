[[ -d "$LOG_DIR" ]] || mkdir -p "$LOG_DIR"

# if file does not exists or is empty, create it.
if [[ ! -s "$ZXZ_LOG_FILE" ]]; then
  create_log_file
fi
