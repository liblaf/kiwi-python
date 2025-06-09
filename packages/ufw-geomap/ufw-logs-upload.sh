#!/usr/bin/env -S usage bash
# shellcheck shell=bash
#USAGE flag "-r --remote <REMOTE>" help="SSH remote host to upload logs to" default="PC05"
set -o errexit
set -o nounset
set -o pipefail

: "${usage_remote:?}"

hostname="$(hostnamectl hostname)"
log_dir_relative=".local/state/liblaf/kiwi/ufw-geomap/log"
log_filename="$hostname.log.jsonl"
local_log_dir="$HOME/$log_dir_relative"
local_log_file="$local_log_dir/$log_filename"

mkdir --parents --verbose "$local_log_dir"
journalctl --boot="all" --identifier="kernel" --grep="^\[UFW BLOCK\]" --output="json" > "$local_log_file"
ssh "$usage_remote" -- "mkdir --parents --verbose \"\$HOME/$log_dir_relative\""
rsync --info="PROGRESS2" --archive --partial --compress --stats --human-readable \
  "$local_log_file" "$usage_remote:$log_dir_relative/$log_filename"
