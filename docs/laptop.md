# `laptop` Setup

Bootstrap process for the `laptop` role.

**The configuration expects a particular disk setup (covered below).**

# Contents

1. [Obtaining a live NixOS image](#1-obtaining-a-live-nixos-image)
2. [Preparing the device](#2-preparing-the-device)
3. [Partitioning disks](#3-partitioning-disks)
4. [Installing NixOS](#4-installing-nixos)
5. [Setting up Secure Boot](#5-setting-up-secure-boot)
6. [Setting up impermanence](#6-setting-up-impermanence)
7. [Adding external disks](#7-adding-external-disks)

## 1. Obtaining a live NixOS image.

1. Get a live NixOS image that has experimental features `flakes` and
   `nix-command` enabled.

   Two such images are included in this flake. To use the included GNOME image:

   ```bash
   nix run nixpkgs#nixos-generators -- \
   --format iso \
   --flake github:sotormd/nixos#imageGnome \
   -o /tmp/gnome-image
   ```

   The generated image will be available under `/tmp/gnome-image/iso/`.

   For more information, see [images.md](./images.md).

2. Write the generated image to a removable medium (eg. a usb stick) using `dd`
   or any equivalent tool.

## 2. Preparing the device.

1. Disable secure boot for installation. It can be enabled later.

2. Boot into the live NixOS image and set the role.

   ```bash
   export NIXOS_ROLE=laptop
   ```

## 3. Partitioning disks.

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
   nix run github:sotormd/nixos#init -- disks boot
   nix run github:sotormd/nixos#init -- disks swap
   nix run github:sotormd/nixos#init -- disks root
   nix run github:sotormd/nixos#init -- disks mount
   ```

   Or alternatively, format and mount the partitions manually by following
   equivalent steps mentioned below.

<details>

<summary>Click to expand: manual steps</summary>

3. Format boot partition.

   ```bash
   sudo mkfs.vfat $BOOT
   ```

4. Enable swap.

   ```bash
   sudo mkswap $SWAP
   sudo swapon $SWAP
   ```

5. Enable `LUKS` encryption.

   ```bash
   sudo cryptsetup luksFormat $ROOT
   sudo cryptsetup luksOpen $ROOT root
   ```

   The partition should be available at `/dev/mapper/root` now.

6. Create `ZFS` pools.

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

7. Create `ZFS` datasets.

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

10. Mount `ZFS` datasets.

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

## 4. Installing NixOS.

1. Set basic environment variables.

   ```bash
   export NIXOS_ROOT_MOUNT=/mnt
   export NIXOS_DIR=/persist/nixos
   ```

2. Clone this flake.

   ```bash
   nix run github:sotormd/nixos#init -- clone
   ```

   The flake will be cloned to `$NIXOS_ROOT_MOUNT$NIXOS_DIR`.

3. Initialize variables and secrets.

   ```bash
   nix run github:sotormd/nixos#init -- vars
   nix run github:sotormd/nixos#init -- sops
   ```

   Variables and secrets can be configured through environment variables while
   bootstrapping, see [this](#environment-variables) list for all available
   environment variables.

4. Edit variables and secrets.

   ```bash
   nix run github:sotormd/nixos#init -- vars edit
   nix run github:sotormd/nixos#init -- sops edit
   ```

   Make sure all variables and secrets are properly defined.

5. Install NixOS

   ```bash
   nix run github:sotormd/nixos#init -- install
   ```

6. Finish installation.

   ```bash
   sudo reboot
   ```

   Remove the removable medium and boot into the newly installed NixOS
   installation.

   You should be able to log in to the sway desktop and use the `nixos` command.

### Environment variables.

You _can_ set all variables and secrets while bootstrapping using these
environment variables.

This is useful if you have a `.env` file you wish to export environment
variables from.

Otherwise, it is simpler to edit the variables and secrets files like mentioned
in step 4.

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
| `VARS_DEVICE_PLYMOUTH_ENABLE`     | Enable `plymouth` boot animations.                 | `"false"`                                         | `"true"`                             |
| `VARS_DEVICE_AUTOCPUFREQ_ENABLE`  | Enable `auto-cpufreq`.                             | `"true"`                                          | `"false"`                            |
| `VARS_DEVICE_POWERTOP_ENABLE`     | Enable `powertop`.                                 | `"false"`                                         | `"true"`                             |
| `VARS_DEVICE_TLP_ENABLE`          | Enable `tlp`.                                      | `"false"`                                         | `"true"`                             |
| `VARS_USER_NAME`                  | Username.                                          | `$USER`                                           | `"Bar"`                              |
| `VARS_USER_EMAIL`                 | Email used for git commits.                        | -                                                 | `"Bar@domain.com"`                   |
| `VARS_USER_GITHUB_KEYFILE`        | Github SSH identity key.                           | `"id_ed25519_github"`                             | `"id_rsa_github"`                    |
| `VARS_I18N_TIMEZONE`              | Timezone.                                          | `$(timedatectl show --property=Timezone --value)` | `"Europe/Berlin"`                    |
| `VARS_I18N_KEYBOARD`              | Keyboard layout.                                   | `"us"`                                            | `"us"`                               |
| `VARS_I18N_LOCALE`                | Locale.                                            | `"en_US.UTF-8"`                                   | `"de_DE.UTF-8"`                      |
| `VARS_NETWORK_INTERFACE`          | Wireless network interface.                        | `"wlp1s0"`                                        | `"wlan0"`                            |
| `VARS_NETWORK_SSID`               | Wireless network ssid.                             | -                                                 | `"net20"`                            |
| `VARS_NETWORK_GATEWAY`            | Wireless network gateway.                          | `"192.168.0.1"`                                   | `"10.0.0.0"`                         |
| `VARS_NETWORK_IP`                 | Static local IP address.                           | -                                                 | `"10.0.0.3"`                         |
| `VARS_NETWORK_WPA3_ENABLE`        | Enable SAE (dragonfly) authentication.             | `"true"`                                          | `"false"`                            |
| `VARS_NETWORK_SERVER_ENABLE`      | Enable server-dependant features.                  | `"true"`                                          | `"false"`                            |
| `VARS_NETWORK_SERVER_IP`          | Static local server IP address.                    | -                                                 | `"10.0.0.5"`                         |
| `VARS_NETWORK_SERVER_DOMAIN`      | Server domain.                                     | -                                                 | `"myserver.domain.com"`              |
| `VARS_NETWORK_SERVER_SSH_PORT`    | Server SSH port.                                   | `"22"`                                            | `"20000"`                            |
| `VARS_NETWORK_SERVER_SSH_KEYFILE` | Server SSH identity key.                           | `"id_ed25519_server"`                             | `"id_rsa"`                           |
| `VARS_NETWORK_SERVER_I2P_PORT`    | Server I2P HTTP proxy port.                        | `"4444"`                                          | `"23001"`                            |
| `VARS_OUTPUTS_LAPTOP`             | Identifier for laptop screen.                      | `"eDP-1"`                                         | `"eDP-1"`                            |
| `VARS_OUTPUTS_MONITOR`            | Identifier for monitor screen.                     | `"HDMI-A-1"`                                      | `"HDMI-A-1"`                         |
| `VARS_OUTPUTS_WALLPAPER`          | Wallpaper name.                                    | `"nord.mario"`                                    | `"nord.nixos"`                       |
| `VARS_OUTPUTS_LOCKSCREEN`         | Lockscreen wallpaper name.                         | `"nord.files"`                                    | `"nord.nixos"`                       |
| `SECRETS_HASHED_PASSWORD`         | Hashed user password.                              | `$(mkpasswd -m yescrypt)`                         | -                                    |
| `SECRETS_PSK`                     | PSK for the network.                               | (user input)                                      | `"supersecretpsk"`                   |

Ensure all variables and secrets are properly defined.

</details>

## 5. Setting up Secure Boot

> WARNING: Secure Boot for NixOS is under active development. Make sure you read
> lanzaboote documentation before proceeding.

> WARNING: If dual booting with Windows, either disable bitlocker encryption or
> keep the recovery keys handy.

1. System requirements.

   Ensure you have booted in UEFI mode and Secure Boot is supported.

   ```bash
   bootctl status
   ```

   Consider setting up a BIOS password if you haven't already.

2. Create secure boot keys.

   ```bash
   nixos init lanzaboote create
   ```

   Set `device.secureboot.enable = true;` in `vars.nix`.
   ```bash
   nixos edit vars
   ```

   Switch to the new configuration.
   ```bash
   nixos switch
   ```

   Verify `sbctl verify` output.

   ```bash
   nix shell nixpkgs#sbctl --command sudo sbctl verify
   ```
   It is expected that `bzImage.efi` files are not signed.

3. Enter Secure Boot setup mode in BIOS.

   Boot into EFI firmware and clear existing plaform keys (setup mode).

4. Boot into NixOS and enroll Secure Boot keys.

   ```bash
   nixos init lanzaboote enroll
   ```

5. Enable Secure Boot in BIOS.

   Boot into EFI firmware and enable Secure Boot.

   Boot into NixOS and Secure Boot should be activated and in user mode.

   ```bash
   bootctl status
   ```

## 6. Setting up impermanence.

> This section assumes Secure Boot is set up and keys are available at
> `/var/lib/sbctl`.

1. Populate the `/persist/` directory.

   ```bash
   nixos init impermanence
   ```

2. Enable impermanence in configuration.

   Set `device.impermanence.enable = true;` in `vars.nix`.

   ```bash
   nixos edit vars
   ```

3. Switch to the new configuration.

   ```bash
   nixos switch
   ```

# **7. Adding External Disks**

External disks—whether **unencrypted**, **LUKS-encrypted**, or **requiring
hdparm tweaks**—can be configured declaratively through `vars.nix`.

Open the variables file:

```console
$ nixos edit vars
```

All configuration happens under the `device.*` sections.

## **5.1 Unencrypted Disks (device.mount)**

Use `device.mount` to configure _plain, unencrypted_ filesystems.

Each attribute key is the mount point, and the value describes the underlying
block device.

### **Example**

```nix
device.mount = {
  "/mnt/media" = {
    device = "/dev/disk/by-uuid/243fdae5-89df-4407-e6163e688f4d";
    fsType = "xfs";
    options = [ "defaults" ];
    neededForBoot = false;
  };

  "/mnt/backup" = {
    device = "/dev/disk/by-partuuid/1b2c3d4e-55ff-8899-aabb-ccddeeff0011";
    fsType = "ext4";
    options = [ "noatime" ];
    neededForBoot = false;
  };
};
```

These are translated directly into `fileSystems` entries during system
generation.

## **5.2 LUKS-Encrypted Disks (device.luks)**

Use `device.luks` to define encrypted volumes that unlock using a keyfile.

Each entry requires:

- `uuid` — LUKS container UUID (`blkid` output)
- `keyfile` — path to keyfile
- `mount` — where the decrypted mapper device should mount
- `fs` — filesystem inside the LUKS container (`ext4`, `xfs`, etc.)

### **Example**

```nix
device.luks = {
  ht02 = {
    uuid = "3f74d2e3-5a67-4b86-b2c3-842f39e45b7a";
    keyfile = "/root/keys/ht02";
    mount = "/mnt/ht02";
    fs = "xfs";
  };

  ht03 = {
    uuid = "5a67d2e3-842f-3f74-b2c3-4b8639e45b7a";
    keyfile = "/root/keys/ht03";
    mount = "/mnt/ht03";
    fs = "ext4";
  };
};
```

### **What happens automatically**

For each entry:

1. A `/etc/crypttab` entry is generated:

   ```
   <name> UUID=<uuid> <keyfile> luks
   ```
2. The device unlocks to `/dev/mapper/<name>`
3. A filesystem entry is created:

   ```
   fileSystems."<mount>" = {
     device = "/dev/mapper/<name>";
     fsType = "<fs>";
   };
   ```

---

## **5.3 hdparm Configuration (device.hdparm)**

Use `device.hdparm` to disable aggressive head-parking or alter disk power
behavior for HDDs.

This accepts a **list of disk IDs** (as used in `/dev/disk/by-id`).

### **Example**

```nix
device.hdparm = [
  "usb-WD_Elements_25A2_575852314134393745303255-0:0"
  "usb-Seagate_Expansion_1234567890ABCDEF-0:0"
];
```

### **What the system generates**

One systemd service per disk:

```
hdparm-0.service
hdparm-1.service
...
```

Each service runs:

```
hdparm -B 254 -S 0 /dev/disk/by-id/<id>
```

This prevents aggressive head parking and increases drive longevity.

## **Summary**

| Feature               | Config Location | Description                              |
| --------------------- | --------------- | ---------------------------------------- |
| **Unencrypted mount** | `device.mount`  | Direct filesystem mounts                 |
| **Encrypted (LUKS)**  | `device.luks`   | Creates crypttab entries + mapper mounts |
| **hdparm tuning**     | `device.hdparm` | Generates systemd services per drive     |
