# IDrive for Unraid

A small container wrapper around IDrive's official Linux package. It is designed
to copy completed, verified Vaultwarden backup archives off-site rather than
backing up the live Vaultwarden database.

> **Status:** Initial public build. IDrive's installer and account setup are
> interactive, so perform the first installation from the Unraid container
> console and validate a backup and restore before relying on it.

## Design

- Official IDrive Linux installer is downloaded during the image build.
- Weekly GitHub Actions rebuilds pick up the latest installer and Ubuntu patches.
- Unraid detects the changed GHCR image through its normal Docker update check.
- IDrive installation and account state persist outside the container.
- Vaultwarden backup archives are mounted read-only.
- No privileged mode, host networking, or Docker socket is required.

## Unraid paths

| Host path | Container path | Access |
|---|---|---|
| `/mnt/user/appdata/idrive/opt` | `/opt/IDriveForLinux` | Read/write |
| `/mnt/user/appdata/idrive/root` | `/root` | Read/write |
| `/mnt/user/CommunityApplicationsAppdataBackup/VaultwardenNightly` | `/backup/VaultwardenNightly` | Read-only |

## First installation

1. Add a container using `ghcr.io/learnthenext/idrive-unraid:latest`.
2. Configure the three mappings above and set the timezone.
3. Start the container.
4. Open its Unraid console.
5. Run:

   ```bash
   install-idrive
   ```

6. Follow IDrive's prompts.
7. Run the IDrive menu later with:

   ```bash
   idrive-cli
   ```

8. Configure the backup set to include only:

   ```text
   /backup/VaultwardenNightly
   ```

9. Schedule IDrive after the local 03:15 Vaultwarden job, for example 04:00.

## Useful commands

```bash
show-status
verify-backups
idrive-cli
update-idrive
```

`verify-backups` validates every `.tar.gz.sha256` file visible in the mounted
Vaultwarden backup directory.

## Updates

The workflow rebuilds the image each Monday. This intentionally catches both:

- a changed IDrive installer; and
- Ubuntu base-image security updates.

After Unraid reports an image update, update the container normally. Then open
the console and run `update-idrive` if the installed IDrive version itself has
not already been updated. The persistent `/opt/IDriveForLinux` mount survives
container replacement.

## Recovery warning

Do not treat setup as complete until you have:

1. uploaded at least one backup;
2. confirmed it appears in IDrive;
3. restored it into a temporary directory; and
4. verified its SHA-256 checksum after restoration.

## Licensing

This repository contains wrapper scripts only. IDrive software is downloaded
from IDrive during the image build and remains subject to IDrive's terms.
