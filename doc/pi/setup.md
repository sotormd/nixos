# Pi Setup

> This document covers setting up the provided `nixosConfiguration`. See
> [`mkConfig` Usage](../mkconfig.md) for customizing roles.

Bootstrap process for the Pi role.

Before proceeding, see [Pi Requirements](./requirements.md).

> Keep in mind that this is my personal configuration for my personal devices.
> It is not meant to be used in other places and will most likely not work.
> Documentation is written to help me setup new devices in the future.

# Contents

1. [Obtaining a NixOS Image](#obtaining-a-nixos-image)
2. [Preparing the Device](#preparing-the-device)
3. [Applying Configuration](#applying-configuration)
4. [Setting up Impermanence](#setting-up-impermanence)
5. [Further Reading](#further-reading)

# Obtaining a NixOS Image

1. Build the SD image.

   For more information, see [Images Documentation](../images.md).

2. Write the generated image to a sd-card using `dd` or any equivalent tool.

3. This document is also available in `/etc/current-flake/doc/pi/setup.md` in
   the installation environment.

# Preparing the Device

1. Boot into the newly created sd-card image on the target device.

2. Connect to the internet.

   ```bash
   nmtui
   ```

3. Ensure a working internet connection.

   ```bash
   ping archlinux.org
   ```

4. Set basic environment variables required by the installer.

   ```bash
   export NIXOS_ROLE=pi
   ```

# Applying Configuration

1. Clone the flake.

   ```bash
   nixos bootstrap clone
   ```

   The flake will be cloned to `/persist/nixos`.

2. Initialize variables & secrets.

   ```bash
   nixos bootstrap vars
   nixos bootstrap sops
   ```

   This step can be skipped if you bring your own pre-existing variables and
   secrets.

3. Edit variables & secrets.

   ```bash
   nixos edit vars
   nixos edit sops
   ```

   Ensure all variables and secrets are properly defined.

4. Make new configuration the boot default.

   ```bash
   nixos apply boot
   ```

   > Exporting `NIXOS_NONFLAKE=1` will apply the configuration without using
   > flakes, see [Non-Flake Usage](../nonflake.md) for more information.

5. Reboot.

   ```bash
   sudo reboot
   ```

# Setting up Impermanence

> This is a post-install action.

1. Populate `/persist/root` with the default directories to persist.

   ```bash
   nixos bootstrap impermanence
   ```

   Also note that if any directories were bind mounted using the variables file
   from external disks to the locations where the services expect them to be,
   these have to be re-evaluated. Impermanence creates its own bind mounts, so
   the variables file should be updated to bind mount things from the external
   disks to `/persist/root` instead.

2. Set `impermanence.enable` to `true` in `features` section of the variables
   file.

   ```bash
   nixos edit vars
   ```

3. Make new configuration the boot default.

   ```bash
   nixos apply boot
   ```

4. Reboot.

   ```bash
   sudo reboot
   ```

For more details, see
[Filesystem and Impermanence Documentation](../filesystems.md).

# Further Reading

- [Pi Usage Documentation](./usage.md)
- [Security Features](../security.md)
- [Filesystem and Impermanence Documentation](../filesystems.md)
- [CLI Documentation](../cli.md)
