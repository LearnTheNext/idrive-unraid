#!/usr/bin/env bash
set -Eeuo pipefail

if [[ -x /opt/IDriveForLinux/bin/idrive ]]; then
    echo "IDrive already appears to be installed."
    echo "Use 'idrive-cli' to configure it or 'update-idrive' to run the official updater."
    exit 0
fi

echo "This launches IDrive's official interactive installer."
echo "Its persistent installation target is /opt/IDriveForLinux."
echo
exec /usr/local/share/idriveforlinux.bin --install
