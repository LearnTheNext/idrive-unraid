#!/usr/bin/env bash
set -Eeuo pipefail

IDRIVE_BIN="/opt/IDriveForLinux/bin/idrive"
IDRIVE_PYTHON_LIB="/opt/IDriveForLinux/bin/Idrivelib/dependencies/python/lib"

if [[ ! -x "${IDRIVE_BIN}" ]]; then
    echo "IDrive is not installed. Run: install-idrive" >&2
    exit 1
fi

if [[ -d "${IDRIVE_PYTHON_LIB}" ]]; then
    export LD_LIBRARY_PATH="${IDRIVE_PYTHON_LIB}${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
fi

cd /opt/IDriveForLinux/bin
exec "${IDRIVE_BIN}" "$@"