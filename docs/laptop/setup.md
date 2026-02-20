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
   export NIXOS_DISKS_DRY_RUN=false
   nixos init disks boot
   nixos init disks swap
   nixos init disks root
   nixos init disks mount
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
   sudo zfs create rpool/root -o mountpoint=legacy
   sudo zfs create rpool/home -o mountpoint=legacy
   sudo zfs create rpool/nix -o mountpoint=legacy
   sudo zfs create rpool/persist -o mountpoint=legacy
   ```

8. Create a reserved dataset.

   ZFS's performance will deteriorate significantly when more than 80% of the
   available space is used - to avoid this, reserve disk space beforehand.

   ```bash
   sudo zfs create rpool/reserved -o refreservation=10G -o mountpoint=none
   ```

9. Create empty snapshots of `rpool/root` and `rpool/home` for impermanence.

   ```bash
   sudo zfs snapshot rpool/root@blank
   sudo zfs snapshot rpool/home@blank
   ```

10. Mount ZFS datasets.

    ```bash
    sudo mkdir -p /mnt && sudo mount rpool/root /mnt -t zfs
    sudo mkdir -p /mnt/home && sudo mount rpool/home /mnt/home -t zfs
    sudo mkdir -p /mnt/nix && sudo mount rpool/nix /mnt/nix -t zfs
    sudo mkdir -p /mnt/persist && sudo mount rpool/persist /mnt/persist -t zfs
    ```

11. Mount boot partition.

    ```bash
    sudo mkdir -p /mnt/boot && sudo mount $BOOT /mnt/boot
    ```

</details>

# Installing NixOS

1. Clone this flake.

   ```bash
   nixos init clone
   ```

   The flake will be cloned to `$NIXOS_ROOT_MOUNT$NIXOS_DIR`.

2. Initialize variables and secrets.

   ```bash
   nixos init vars
   nixos init sops
   ```

   Variables and secrets can be configured through environment variables while
   bootstrapping, see [this](#environment-variables) list for all available
   environment variables.

3. Edit variables and secrets.

   ```bash
   nixos init vars edit
   nixos init sops edit
   ```

   Make sure all variables and secrets are properly defined.

4. Install NixOS

   ```bash
   nixos init install
   ```

5. Finish installation.

   ```bash
   sudo reboot
   ```

   Remove the removable medium and boot into the newly installed NixOS
   installation.

   You should be able to log in to the sway desktop and use the `nixos` command.

## Environment variables

You _can_ set all variables and secrets while bootstrapping using these
environment variables.

This is useful if you have a `.env` file you wish to export environment
variables from.

Otherwise, it is simpler to edit the variables and secrets files like mentioned
in step 3.

<details>

<summary>Click to expand: full list of possible environment variables</summary>

| Name                              | Explanation                                        | Default                                           | Example                              |
| --------------------------------- | -------------------------------------------------- | ------------------------------------------------- | ------------------------------------ |
| `NIXOS_DIR`                       | Directory where the NixOS configuration is stored. | -                                                 | `"/persist/nixos"`                   |
| `NIXOS_ROLE`                      | `laptop` or `server` role                          | -                                                 | `"laptop"`                           |
| `VARS_DEVICE_HOSTNAME`            | Hostname of the device.                            | `$(uname -n)`                                     | `"Foo"`                              |
| `VARS_DEVICE_MACHINEID`           | `systemd` machine-id.                              | `$(cat /etc/machine-id)`                          | `"51934ba93b754bf28caf413f7e6c65bd"` |
| `VARS_DEVICE_HOSTID`              | Host ID, required for `ZFS`.                       | `$(head -c 8 /etc/machine-id)`                    | `"51934b"`                           |
| `VARS_DEVICE_BOOT`                | Boot partition partuuid.                           | `"$BOOT"`                                         | -                                    |
| `VARS_DEVICE_SWAP`                | Swap partition partuuid.                           | `"$SWAP"`                                         | -                                    |
| `VARS_DEVICE_ROOT`                | Root partition partuuid.                           | `"$ROOT"`                                         | -                                    |
| `VARS_DEVICE_SECUREBOOT_ENABLE`   | Enable secure boot.                                | `"false"`                                         | `"true"`                             |
| `VARS_DEVICE_IMPERMANENCE_ENABLE` | Enable impermanence.                               | `"false"`                                         | `"true"`                             |
| `VARS_USER_NAME`                  | Username.                                          | `$USER`                                           | `"Bar"`                              |
| `VARS_USER_EMAIL`                 | Email used for git commits.                        | `"$USER@nixos"`                                   | `"Bar@domain.com"`                   |
| `VARS_USER_GITHUB`                | Github SSH identity key.                           | `"id_ed25519_github_$VARS_DEVICE_HOSTNAME"`       | `"id_rsa_github"`                    |
| `VARS_USER_CODEBERG`              | Codeberg SSH identity key.                         | `"id_ed25519_codeberg_$VARS_DEVICE_HOSTNAME"`     | `"id_rsa_codeberg"`                  |
| `VARS_I18N_TIMEZONE`              | Timezone.                                          | `$(timedatectl show --property=Timezone --value)` | `"Europe/Berlin"`                    |
| `VARS_I18N_KEYBOARD`              | Keyboard layout.                                   | `"us"`                                            | `"us"`                               |
| `VARS_I18N_LOCALE`                | Locale.                                            | `"en_US.UTF-8"`                                   | `"de_DE.UTF-8"`                      |
| `VARS_NETWORK_INTERFACE`          | Wireless network interface.                        | `"wlp1s0"`                                        | `"wlan0"`                            |
| `VARS_NETWORK_SSID`               | Wireless network ssid.                             | `"net"`                                           | `"net20"`                            |
| `VARS_NETWORK_GATEWAY`            | Wireless network gateway.                          | `"192.168.0.1"`                                   | `"10.0.0.0"`                         |
| `VARS_NETWORK_IP`                 | Static local IP address.                           | `"192.168.0.100"`                                 | `"10.0.0.3"`                         |
| `VARS_NETWORK_WPA3_ENABLE`        | Enable SAE (dragonfly) authentication.             | `"true"`                                          | `"false"`                            |
| `VARS_NETWORK_SERVER_ENABLE`      | Enable server-dependant features.                  | `"false"`                                         | `"false"`                            |
| `VARS_NETWORK_SERVER_IP`          | Static local server IP address.                    | `"192.168.0.200"`                                 | `"10.0.0.5"`                         |
| `VARS_NETWORK_SERVER_DOMAIN`      | Server domain.                                     | `"nixos-server.duckdns.org"`                      | `"myserver.domain.com"`              |
| `VARS_NETWORK_SERVER_SSH_PORT`    | Server SSH port.                                   | `"22"`                                            | `"20000"`                            |
| `VARS_NETWORK_SERVER_SSH_KEYFILE` | Server SSH identity key.                           | `"id_ed25519_server"`                             | `"id_rsa"`                           |
| `VARS_NETWORK_SERVER_I2P_PORT`    | Server I2P HTTP proxy port.                        | `"4444"`                                          | `"23001"`                            |
| `VARS_OUTPUTS_LAPTOP`             | Identifier for laptop screen.                      | `"eDP-1"`                                         | `"eDP-1"`                            |
| `VARS_OUTPUTS_MONITOR`            | Identifier for monitor screen.                     | `"HDMI-A-1"`                                      | `"HDMI-A-1"`                         |
| `VARS_OUTPUTS_WALLPAPER`          | Wallpaper name.                                    | `"nord.space"`                                    | `"oc.nixos"`                         |
| `VARS_OUTPUTS_LOCKSCREEN`         | Lockscreen wallpaper name.                         | `"xkcd.random"`                                   | `"oc.nixos"`                         |
| `SECRETS_HASHED_PASSWORD`         | Hashed user password.                              | `$(mkpasswd -m yescrypt)`                         | -                                    |
| `SECRETS_PSK`                     | PSK for the network.                               | (user input)                                      | `"supersecretpsk"`                   |

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
