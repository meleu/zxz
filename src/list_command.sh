# inspect_args && exit

if [[ "${ARGS[--update]}" == 1 ]]; then
  update_log_file
fi

print_uploaded_files
