# `laptop` Setup

Bootstrap process for the `laptop` role.

# Contents

1. [Obtaining a Live NixOS Image](#obtaining-a-live-nixos-image)
2. [Preparing the Device](#preparing-the-device)
3. [Partitioning Disks](#partitioning-disks)
4. [Installing NixOS](#installing-nixos)
5. [Further Setup](#further-setup)

# Obtaining a Live NixOS Image

1. Download either of the two included images for `x86_64-linux`: `minimal` or
   `gnome`. For more information, see [images.md](./images.md).

2. Write the generated image to a removable medium (eg. a usb stick) using `dd`
   or any equivalent tool.

# Preparing the Device

1. Disable secure boot for installation. It can be enabled later.

2. Boot into the live NixOS image.

3. Connect to the internet.

   ```bash
   nmtui
   ```

4. Ensure a working internet connection.

   ```bash
   ping archlinux.org
   ```

5. Set basic environment variables required by the installer.

   ```bash
   export NIXOS_ROLE=laptop
   export NIXOS_DIR=/persist/nixos
   export NIXOS_ROOT_MOUNT=/mnt
   ```

   > You can use any `NIXOS_DIR` you like, but the `NIXOS_ROOT_MOUNT` must be
   > set to `/mnt` for the install scripts to work.

## Partitioning Disks

> **disko:** This flake doesn't use disko keeping dual booting in mind.

1. Create three partitions using `parted` or `gparted`.

   If creating a new partition table, use the `gpt` format.

   | Partition | Example Size    |
   | --------- | --------------- |
   | BOOT      | ~4G             |
   | SWAP      | ~8G             |
   | ROOT      | remaining space |

   Remember to mark the BOOT partition as ESP.

2. Assign variables to the partitions for ease of use.

   ```bash
   export BOOT=/dev/disk/by-partuuid/aaa...
   export SWAP=/dev/disk/by-partuuid/bbb...
   export ROOT=/dev/disk/by-partuuid/ccc...
   ```

   To find the partuuids:

   ```bash
   sudo blkid
   ```

3. Format and mount partitions for installation.

   ```bash
   export DISKS_DRY_RUN=false
   nixos bootstrap disks boot
   nixos bootstrap disks swap
   nixos bootstrap disks root
   nixos bootstrap disks mount
   ```

   Or alternatively, format and mount the partitions manually by following
   equivalent steps mentioned below. This is useful if you want more control
   over the process. For example: you already have a ZFS pool you wish to
   import, or you want to use different ZFS options while creating the
   pool/datasets. Remember that after everything is complete, the new system
   should be available under `$NIXOS_ROOT_MOUNT`.

<details>

<summary>Click to expand: manual steps</summary>

3. Format boot partition.

   ```bash
   sudo mkfs.vfat -F 32 -n BOOT $BOOT
   ```

4. Enable swap.

   ```bash
   sudo mkswap $SWAP
   sudo swapon $SWAP
   ```

5. Enable LUKS encryption.

   ```bash
   sudo cryptsetup luksFormat $ROOT
   sudo cryptsetup luksOpen $ROOT root
   ```

   The partition should be available at `/dev/mapper/root` now.

6. Create ZFS pools.

   ```bash
   sudo zpool create \
   -O compression=lz4 \
   -O xattr=sa \
   -O acltype=posixacl \
   -O atime=off \
   -O mountpoint=none \
   -o ashift=12 \
   rpool \
   /dev/mapper/root
   ```

   | Attribute   | Value    | Explanation                                                                                                |
   | ----------- | -------- | ---------------------------------------------------------------------------------------------------------- |
   | compression | lz4      | Enables **lz4** compression, which is fast and provides good compression ratios.                           |
   | xattr       | sa       | Stores extended attributes in system attribute space instead of hidden directories, improving performance. |
   | acltype     | posixacl | Enables **POSIX ACLs** for fine-grained permission control.                                                |
   | atime       | off      | Disables access time updates on files, which improves performance by reducing disk writes.                 |
   | mountpoint  | none     | Prevents automatic mounting of zpool, useful for NixOS.                                                    |
   | ashift      | 12       | Sets the sector size to **4K (2^12)**, optimal for modern storage devices (SSDs and advanced format HDDs). |

7. Create ZFS datasets.

   ```bash
   sudo zfs create rpool/nixos
   sudo zfs create rpool/nixos/root -o mountpoint=legacy
   sudo zfs create rpool/nixos/home -o mountpoint=legacy
   sudo zfs create rpool/nixos/nix -o mountpoint=legacy
   sudo zfs create rpool/nixos/persist -o mountpoint=legacy
   ```

8. Create empty snapshots of `rpool/nixos/root` and `rpool/nixos/home` for
   impermanence.

   ```bash
   sudo zfs snapshot rpool/nixos/root@blank
   sudo zfs snapshot rpool/nixos/home@blank
   ```

9. Mount ZFS datasets.

   ```bash
   sudo mkdir -p /mnt && sudo mount rpool/nixos/root /mnt -t zfs
   sudo mkdir -p /mnt/home && sudo mount rpool/nixos/home /mnt/home -t zfs
   sudo mkdir -p /mnt/nix && sudo mount rpool/nixos/nix /mnt/nix -t zfs
   sudo mkdir -p /mnt/persist && sudo mount rpool/nixos/persist /mnt/persist -t zfs
   ```

10. Mount boot partition.

    ```bash
    sudo mkdir -p /mnt/boot && sudo mount $BOOT /mnt/boot
    ```

</details>

# Installing NixOS

1. Clone this flake.

   ```bash
   nixos bootstrap clone
   ```

   The flake will be cloned to `$NIXOS_ROOT_MOUNT$NIXOS_DIR`.

2. Initialize variables and secrets.

   ```bash
   nixos bootstrap vars
   nixos bootstrap sops
   ```

   Variables and secrets can be configured through environment variables while
   bootstrapping, see [this](#environment-variables) list for all available
   environment variables.

3. Edit variables and secrets.

   ```bash
   nixos edit vars
   nixos edit sops
   ```

   Make sure all variables and secrets are properly defined.

4. Install NixOS

   ```bash
   nixos bootstrap install
   ```

5. Finish installation.

   ```bash
   sudo reboot
   ```

   Remove the removable medium and boot into the newly installed NixOS
   installation.

## Environment variables

You _can_ set all variables and secrets while bootstrapping using these
environment variables.

This is useful if you have a `.env` file you wish to export environment
variables from.

Otherwise, it is simpler to edit the variables and secrets files like mentioned
in step 3.

<details>

<summary>Click to expand: full list of possible environment variables</summary>

| Name                               | Explanation                              | Default                                           |
| ---------------------------------- | ---------------------------------------- | ------------------------------------------------- |
| `VARS_DEVICE_HOSTNAME`             | Hostname of the device.                  | `$(uname -n)`                                     |
| `VARS_DEVICE_MACHINEID`            | `systemd` machine-id.                    | `$(cat /etc/machine-id)`                          |
| `VARS_DEVICE_HOSTID`               | Host ID, required for `ZFS`.             | `$(head -c 8 /etc/machine-id)`                    |
| `VARS_PARTITIONS_BOOT`             | Boot partition identifier.               | `${BOOT##*/}`                                     |
| `VARS_PARTITIONS_SWAP`             | Swap partition identifier.               | `${SWAP##*/}`                                     |
| `VARS_PARTITIONS_ROOT`             | Root partition identifier.               | `${ROOT##*/}`                                     |
| `VARS_USER_NAME`                   | Username.                                | `$USER`                                           |
| `VARS_USER_EMAIL`                  | Email address.                           | `$USER@$VARS_DEVICE_HOSTNAME`                     |
| `VARS_USER_GITHUB_KEYFILE`         | Github SSH identity key path.            | `/home/$VARS_USER_NAME/.ssh/id_ed25519_github`    |
| `VARS_USER_CODEBERG_KEYFILE`       | Codeberg SSH identity key path.          | `/home/$VARS_USER_NAME/.ssh/id_ed25519_codeberg`  |
| `VARS_I18N_TIMEZONE`               | Timezone.                                | `$(timedatectl show --property=Timezone --value)` |
| `VARS_I18N_KEYBOARD`               | Keyboard layout.                         | `"us"`                                            |
| `VARS_I18N_LOCALE`                 | Locale.                                  | `"en_US.UTF-8"`                                   |
| `VARS_NETWORK_INTERFACE`           | Wireless network interface.              | `"wlp1s0"`                                        |
| `VARS_NETWORK_SSID`                | Wireless network SSID.                   | `"net"`                                           |
| `VARS_NETWORK_GATEWAY`             | Network gateway address.                 | `"192.168.0.1"`                                   |
| `VARS_NETWORK_ADDRESS`             | Static local IP address.                 | `"192.168.0.100"`                                 |
| `VARS_NETWORK_SERVER_ADDRESS`      | Static local server IP address.          | `"192.168.0.200"`                                 |
| `VARS_NETWORK_SERVER_DOMAIN`       | Server domain.                           | `"example.duckdns.org"`                           |
| `VARS_DISPLAYS_LAPTOP_IDENTIFIER`  | Identifier for laptop display.           | `"eDP-1"`                                         |
| `VARS_DISPLAYS_LAPTOP_RESOLUTION`  | Laptop display resolution.               | `"1920x1200"`                                     |
| `VARS_DISPLAYS_LAPTOP_REFRESH`     | Laptop display refresh rate.             | `"60Hz"`                                          |
| `VARS_DISPLAYS_LAPTOP_POSITION`    | Laptop display position.                 | `"0 0"`                                           |
| `VARS_DISPLAYS_MONITOR_IDENTIFIER` | Identifier for external monitor display. | `"HDMI-A-1"`                                      |
| `VARS_DISPLAYS_MONITOR_RESOLUTION` | External monitor resolution.             | `"1920x1080"`                                     |
| `VARS_DISPLAYS_MONITOR_REFRESH`    | External monitor refresh rate.           | `"60Hz"`                                          |
| `VARS_DISPLAYS_MONITOR_POSITION`   | External monitor position.               | `"1920 0"`                                        |
| `SECRETS_HASHED_PASSWORD`          | Hashed user password.                    | (user input)                                      |
| `SECRETS_PSK`                      | PSK for the network.                     | (user input)                                      |

Ensure all variables and secrets are properly defined.

</details>

# Further Setup

At this point, this flake has been installed on the device.

For further setup, see:

1. [Secure Boot](./secureboot.md)

   For setting up Secure Boot with lanzaboote.

2. [Impermanence](./impermanence.md)

   For setting up impermanence.

3. [Usage](./usage.md)

   For using the `laptop` role.
