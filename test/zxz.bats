#!/usr/bin/env bats
# shellcheck disable=2139,2034,2317,2314

export ZXZ_LOG_FILE='./test-uploads.log'

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  load ../zxz
  initialize
}

teardown() {
  rm -f "$ZXZ_LOG_FILE"
}

@test "upload_command returns a URL and updates the log" {
  local file='somefile'
  local fake_url='https://0x0.st/FAKE.txt'
  # mock cmd_curl
  cmd_curl() {
    echo "$fake_url"
  }

  assert_equal "$fake_url" "$(upload_command "$file")"
  # grep -vq "${file};${fake_url};" "$ZXZ_LOG_FILE"
  grep -q "^${file};${fake_url};" "$ZXZ_LOG_FILE"
}

@test "upload_command fails with no argument" {
  ! upload_command
}

@test "remove_url_from_log does its job" {
  local file='somefile'
  local fake_url='https://0x0.st/FAKE.txt'
  echo \
    "${file};${fake_url};secret-token;2021-01-01 00:00:00;2022-01-01 00:00:00" \
    >> "$ZXZ_LOG_FILE"

  remove_url_from_log 'https://0x0.st/FAKE.txt'

  grep -vq 'https://0x0.st/FAKE.txt' "$ZXZ_LOG_FILE"
}
