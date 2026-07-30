#!/usr/bin/env bash
set -Eeuo pipefail

if [[ ! -x /opt/IDriveForLinux/bin/idrive ]]; then
    echo "IDrive is not installed. Run: install-idrive" >&2
    exit 1
fi

echo "This launches IDrive's official interactive update process."
echo "The installer bundled in the current container image will be used."
echo
exec /usr/local/share/idriveforlinux.bin --update
