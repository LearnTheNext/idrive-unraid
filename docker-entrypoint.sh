#!/usr/bin/env bash
set -Eeuo pipefail

IDRIVE_BIN="/opt/IDriveForLinux/bin/idrive"
IDRIVE_CRON="/etc/idrivecron"
IDRIVE_CRON_LOG="/var/log/idrivecron.log"

start_idrive_cron() {
    if [[ ! -x "$IDRIVE_BIN" ]]; then
        echo "IDrive is not installed."
        echo "Run 'install-idrive' inside the container to install it."
        return 0
    fi

    # /etc is recreated with every new container, while /opt is persistent.
    ln -sfn "$IDRIVE_BIN" "$IDRIVE_CRON"

    echo "Starting IDrive Cron service..."

    "$IDRIVE_CRON" --cron >>"$IDRIVE_CRON_LOG" 2>&1 &

    sleep 2

    if kill -0 "$!" 2>/dev/null; then
        echo "IDrive Cron service started."
    else
        echo "Warning: IDrive Cron exited during startup."
        echo "Check $IDRIVE_CRON_LOG for details."
        cat "$IDRIVE_CRON_LOG" 2>/dev/null || true
    fi
}

start_idrive_cron

exec "$@"