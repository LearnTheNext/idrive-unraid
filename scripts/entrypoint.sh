#!/usr/bin/env bash
set -Eeuo pipefail

log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

mkdir -p /opt/IDriveForLinux /root /var/log/idrive-wrapper

if [[ -n "${TZ:-}" ]] && [[ -e "/usr/share/zoneinfo/${TZ}" ]]; then
    ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
    printf '%s\n' "${TZ}" > /etc/timezone
fi

# IDrive uses scheduled background work. Keep the system cron daemon available.
cron

if [[ -x /opt/IDriveForLinux/bin/idrive ]]; then
    log "IDrive installation detected."
else
    log "IDrive is not installed in the persistent /opt/IDriveForLinux volume."
    log "Open the Unraid container console and run: install-idrive"
fi

log "Official installer checksum bundled in this image:"
cat /usr/local/share/idriveforlinux.bin.sha256
log "Container is ready."

# Keep the container alive while cron and IDrive-managed services operate.
exec tail -F /dev/null
