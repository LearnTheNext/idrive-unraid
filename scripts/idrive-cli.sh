#!/usr/bin/env bash
set -Eeuo pipefail

IDRIVE_BIN=/opt/IDriveForLinux/bin/idrive

if [[ ! -x "$IDRIVE_BIN" ]]; then
    echo "IDrive is not installed. Run: install-idrive" >&2
    exit 1
fi

cd /opt/IDriveForLinux/bin
exec "$IDRIVE_BIN" "$@"
