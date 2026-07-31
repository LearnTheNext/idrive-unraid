FROM ubuntu:24.04

ARG IDRIVE_INSTALLER_URL="https://www.idrivedownloads.com/downloads/linux/download-for-linux/linux-bin/idriveforlinux.bin"
ARG BUILD_DATE="unknown"
ARG VCS_REF="unknown"

LABEL org.opencontainers.image.title="IDrive for Unraid" \
      org.opencontainers.image.description="Container wrapper for the official IDrive for Linux package" \
      org.opencontainers.image.source="https://github.com/LearnTheNext/idrive-unraid" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${VCS_REF}"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    IDRIVE_HOME=/opt/IDriveForLinux \
    BACKUP_ROOT=/backup/VaultwardenNightly \
    EDITOR=nano \
    VISUAL=nano

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        coreutils \
        cron \
        curl \
        findutils \
        libexpat1 \
        nano \
        procps \
        tini \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN ldconfig -p | grep -q 'libexpat\.so\.1' \
    || { echo "Missing required runtime library: libexpat.so.1"; exit 1; }

RUN curl \
        --fail \
        --location \
        --retry 5 \
        --retry-delay 5 \
        --output /usr/local/share/idriveforlinux.bin \
        "${IDRIVE_INSTALLER_URL}" \
    && chmod 0755 /usr/local/share/idriveforlinux.bin \
    && sha256sum /usr/local/share/idriveforlinux.bin \
        > /usr/local/share/idriveforlinux.bin.sha256

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint
COPY scripts/install-idrive.sh /usr/local/bin/install-idrive
COPY scripts/update-idrive.sh /usr/local/bin/update-idrive
COPY scripts/idrive-cli.sh /usr/local/bin/idrive-cli
COPY scripts/show-status.sh /usr/local/bin/show-status
COPY scripts/verify-backups.sh /usr/local/bin/verify-backups
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod 0755 \
        /usr/local/bin/entrypoint \
        /usr/local/bin/install-idrive \
        /usr/local/bin/update-idrive \
        /usr/local/bin/idrive-cli \
        /usr/local/bin/show-status \
        /usr/local/bin/verify-backups \
        /usr/local/bin/docker-entrypoint.sh

VOLUME ["/opt/IDriveForLinux", "/root"]

HEALTHCHECK \
    --interval=5m \
    --timeout=20s \
    --start-period=1m \
    --retries=3 \
    CMD /usr/local/bin/show-status --healthcheck

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["sleep", "infinity"]