#!/usr/bin/env bash
set -Eeuo pipefail

BACKUP_DIR="${BACKUP_ROOT:-/backup/VaultwardenNightly}"
shopt -s nullglob
checksums=("${BACKUP_DIR}"/*.tar.gz.sha256)

if (( ${#checksums[@]} == 0 )); then
    echo "No checksum files found in ${BACKUP_DIR}." >&2
    exit 1
fi

cd "$BACKUP_DIR"
failed=0
for checksum_path in "${checksums[@]}"; do
    checksum_file="$(basename "$checksum_path")"
    if ! sha256sum --check "$checksum_file"; then
        failed=1
    fi
done

exit "$failed"
