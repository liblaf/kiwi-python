#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

function package() {
  install -D --mode="u=rw,go=r" --target-directory="$HOME/.config/systemd/user/" --verbose \
    "geoip-update.service" \
    "geoip-update.timer" \
    "ufw-logs-upload.service" \
    "ufw-logs-upload.timer"

  install -D --mode="u=rwx,go=rx" --target-directory="$HOME/.local/bin/" --verbose \
    "ufw-geomap-publish.sh" \
    "ufw-logs-upload.sh"

  systemctl --user daemon-reload
  systemctl --user enable --now geoip-update.timer
  systemctl --user enable --now ufw-logs-upload.timer
}

package
