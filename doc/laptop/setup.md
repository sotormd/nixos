# Laptop Setup

Bootstrap process for the Laptop role.

Before proceeding, see [Laptop Requirements](./requirements.md).

> Keep in mind that this is my personal configuration for my personal devices.
> It is not meant to be used in other places and will most likely not work.
> Documentation is written to help me setup new devices in the future.

# Contents

1. [Obtaining a Live NixOS Image](#obtaining-a-live-nixos-image)
2. [Preparing the Device](#preparing-the-device)
3. [Partitioning Disks](#partitioning-disks)
4. [Installing NixOS](#installing-nixos)
5. [Setting up Secure Boot](#setting-up-secure-boot)
6. [Setting up Impermanence](#setting-up-impermanence)
7. [Further Reading](#further-reading)

# Obtaining a Live NixOS Image

1. Build any of the two included images for `x86_64-linux`: GNOME or Minimal.

   For more information, see [Images Documentation](../images.md).

2. Write the generated image to a removable medium (eg. a usb stick) using `dd`
   or any equivalent tool.

3. This document is also available in `/etc/current-flake/doc/laptop/setup.md`
   in the installation environment.

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
   export NIXOS_MOUNT=/mnt
   ```

> The installer will refuse to install NixOS if NIXOS_MOUNT is not /mnt.

# Partitioning Disks

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
   nixos bootstrap disks boot apply
   nixos bootstrap disks swap apply
   nixos bootstrap disks root apply
   nixos bootstrap disks mount apply
   ```

   > Run without `apply` for a dry-run.

   Or alternatively, format and mount the partitions manually by following
   equivalent steps mentioned below.

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
   sudo zfs create rpool/nixos/var -o mountpoint=legacy
   sudo zfs create rpool/nixos/etc -o mountpoint=legacy
   sudo zfs create rpool/nixos/srv -o mountpoint=legacy
   sudo zfs create rpool/nixos/nix -o mountpoint=legacy
   sudo zfs create rpool/nixos/persist -o mountpoint=legacy
   ```

8. Create empty snapshots of `rpool/nixos/root` and `rpool/nixos/home` for
   Impermanence.

   ```bash
   sudo zfs snapshot rpool/nixos/root@blank
   sudo zfs snapshot rpool/nixos/home@blank
   sudo zfs snapshot rpool/nixos/var@blank
   sudo zfs snapshot rpool/nixos/etc@blank
   sudo zfs snapshot rpool/nixos/srv@blank
   ```

9. Mount ZFS datasets.

   ```bash
   sudo mkdir -p /mnt && sudo mount rpool/nixos/root /mnt -t zfs
   sudo mkdir -p /mnt/home && sudo mount rpool/nixos/home /mnt/home -t zfs
   sudo mkdir -p /mnt/var && sudo mount rpool/nixos/var /mnt/var -t zfs
   sudo mkdir -p /mnt/etc && sudo mount rpool/nixos/etc /mnt/etc -t zfs
   sudo mkdir -p /mnt/srv && sudo mount rpool/nixos/srv /mnt/srv -t zfs
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

   The flake will be cloned to `$NIXOS_MOUNT/persist/nixos`.

2. Initialize variables and secrets.

   ```bash
   nixos bootstrap vars
   nixos bootstrap sops
   ```

   This step can be skipped if you bring your own pre-existing variables and
   secrets.

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

5. Finish installation and reboot.

   ```bash
   nixos bootstrap finish
   sudo reboot
   ```

   Remove the removable medium and boot into the newly installed NixOS
   installation.

# Setting up Secure Boot

> This is a post-install action.

> Secure Boot for NixOS is under active development. Make sure you read
> lanzaboote documentation before proceeding.

> If dual booting with Windows, either disable bitlocker encryption or keep the
> recovery keys handy.

> It is highly recommended to set a BIOS password on devices that support this
> feature. Without a BIOS password, Secure Boot can simply be disabled and is
> meaningless.

1. System requirements.

   Ensure you have booted in UEFI mode and Secure Boot is supported.

   ```bash
   bootctl status
   ```

   Consider setting up a BIOS password if you haven't already.

2. Create secure boot keys.

   ```bash
   nixos bootstrap lanzaboote create
   ```

3. Set `secureboot.enable` to `true` in the `features` section of the variables
   file.

   ```bash
   nixos edit vars
   ```

4. Switch to the new configuration.

   ```bash
   nixos apply switch
   ```

5. Verify `sbctl verify` output.

   ```bash
   sbctl verify
   ```

   It is expected that `bzImage.efi` files are not signed.

6. Enter Secure Boot setup mode in BIOS.

   Boot into EFI firmware and clear existing plaform keys (setup mode).

7. Boot into NixOS and enroll Secure Boot keys.

   ```bash
   nixos bootstrap lanzaboote enroll
   ```

8. Enable Secure Boot in BIOS.

   Boot into EFI firmware and enable Secure Boot.

9. Boot into NixOS and Secure Boot should be activated and in user mode.

   ```bash
   bootctl status
   ```

# Setting up Impermanence

> This is a post-install action.

> Impermanence requires Secure Boot to be set up and keys available at
> `/var/lib/sbctl`.

1. Populate `/persist/root` with the default directories to persist.

   ```bash
   nixos bootstrap impermanence
   ```

2. Set `impermanence.enable` to `true` in `features` section of the variables
   file.

   ```bash
   nixos edit vars
   ```

3. Switch to the new configuration.

   ```bash
   nixos apply switch
   ```

For more details, see
[Filesystem and Impermanence Documentation](../filesystems.md).

# Further Reading

- [Laptop Usage Documentation](./usage.md)
