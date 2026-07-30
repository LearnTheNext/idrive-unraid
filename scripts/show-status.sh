#!/usr/bin/env bash
set -Eeuo pipefail

healthcheck=false
[[ "${1:-}" == "--healthcheck" ]] && healthcheck=true

if [[ ! -x /opt/IDriveForLinux/bin/idrive ]]; then
    if "$healthcheck"; then
        # Initial setup is intentionally manual; do not mark the container unhealthy.
        exit 0
    fi
    echo "IDrive: not installed"
    echo "Next step: open the container console and run 'install-idrive'."
    exit 0
fi

if [[ ! -d /backup/VaultwardenNightly ]]; then
    echo "Backup mount missing: /backup/VaultwardenNightly" >&2
    exit 1
fi

echo "IDrive: installed"
echo "IDrive CLI: /opt/IDriveForLinux/bin/idrive"
echo "Backup source: /backup/VaultwardenNightly"
echo "Bundled installer: $(sha256sum /usr/local/share/idriveforlinux.bin | awk '{print $1}')"
