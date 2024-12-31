if [[ "${ARGS['--copy-url']}" == 1 ]]; then
  pick_and_copy_url
  return
fi

if [[ "${ARGS['--browser']}" == 1 ]]; then
  pick_and_open_url
  return
fi

[[ "${ARGS['--update']}" == 1 ]] && update_log_file

print_uploaded_files
