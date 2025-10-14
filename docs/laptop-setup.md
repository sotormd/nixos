# `laptop` Setup

To skip installation and directly apply configuration on a system with experimental features `flakes` and `nix-command` enabled, skip to [this](#5-applying-configuration) section.

**The configuration expects a particular disk setup.**

## 1. Obtaining a live NixOS image.

1. Get a NixOS image from [here](https://nixos.org/download/).

2. Verify the checksum of the image.

    ```console
    $ echo "cba2... nixos-...iso" | sha256sum --check
    ```

## 2. Preparing the device.

1. Disable secure boot for installation. It can be enabled later.

2. Boot into the live NixOS image.

## 3. Partitioning disks.

> **disko:** This flake doesn't use disko keeping dual booting in mind.

1. Create three partitions using `parted` or `gparted`.

    If creating a new partition table, use the `gpt` format.

    | Partition | Example Size    |
    |-----------|-----------------|
    | BOOT      | ~4G             |
    | SWAP      | ~8G             |
    | ROOT      | remaining space |

    Remember to mark the BOOT partition as ESP.

2. Assign variables to the partitions for ease of use.

    ```console
    $ sudo blkid
    /dev/nvme0n1p1: ... PARTUUID="aaa.."
    /dev/nvme0n1p2: ... PARTUUID="bbb.."
    /dev/nvme0n1p3: ... PARTUUID="ccc.."
    ```

    ```console
    $ export BOOT=/dev/disk/by-partuuid/aaa...
    $ export SWAP=/dev/disk/by-partuuid/bbb...
    $ export ROOT=/dev/disk/by-partuuid/ccc...
    ```

3. Format boot partition.

    ```console
    $ sudo mkfs.vfat $BOOT
    ```

4. Enable swap.

    ```console
    $ sudo mkswap $SWAP
    $ sudo swapon $SWAP
    ```

5. Enable `LUKS` encryption.

    ```console
    $ sudo cryptsetup luksFormat $ROOT
    $ sudo cryptsetup luksOpen $ROOT root
    ```

    The partition should be available at `/dev/mapper/root` now.

5. Create `ZFS` pools.

    ```console
    $ sudo zpool create \
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
    |-------------|----------|------------------------------------------------------------------------------------------------------------|
    | compression | lz4      | Enables **lz4** compression, which is fast and provides good compression ratios.                           |
    | xattr       | sa       | Stores extended attributes in system attribute space instead of hidden directories, improving performance. |
    | acltype     | posixacl | Enables **POSIX ACLs** for fine-grained permission control.                                                |
    | atime       | off      | Disables access time updates on files, which improves performance by reducing disk writes.                 |
    | mountpoint  | none     | Prevents automatic mounting of zpool, useful for NixOS.                                                    |
    | ashift      | 12       | Sets the sector size to **4K (2^12)**, optimal for modern storage devices (SSDs and advanced format HDDs). |

6. Create `ZFS` datasets.

    ```console
    $ sudo zfs create rpool/root -o mountpoint=legacy
    $ sudo zfs create rpool/home -o mountpoint=legacy
    $ sudo zfs create rpool/nix -o mountpoint=legacy
    $ sudo zfs create rpool/persist -o mountpoint=legacy
    ```

7. Create a reserved dataset.

    ZFS's performance will deteriorate significantly when more than 80% of the available space is used - to avoid this, reserve disk space beforehand.

    ```console
    $ sudo zfs create rpool/reserved -o refreservation=10G -o mountpoint=none
    ```

8. Create empty snapshots of `rpool/root` and `rpool/home` for impermanence.

    ```console
    $ sudo zfs snapshot rpool/root@blank
    $ sudo zfs snapshot rpool/home@blank
    ```

9. Mount `ZFS` datasets.

    ```console
    $ sudo mkdir -p /mnt && sudo mount rpool/root /mnt -t zfs
    $ sudo mkdir -p /mnt/home && sudo mount rpool/home /mnt/home -t zfs
    $ sudo mkdir -p /mnt/nix && sudo mount rpool/nix /mnt/nix -t zfs
    $ sudo mkdir -p /mnt/persist && sudo mount rpool/persist /mnt/persist -t zfs
    ```

10. Mount boot partition.

    ```console
    $ sudo mkdir -p /mnt/boot && sudo mount $BOOT /mnt/boot
    ```

## 4. Installing NixOS.

1. Generate NixOS configuration.

    ```console
    $ sudo nixos-generate-config --root /mnt
    ```

2. Modify the generated configuration.

    `/mnt/etc/nixos/configuration.nix`

    ```nix
    {
    # rest of the config
    # ...

        # flake support
        nix.settings.experimental-features = ["nix-command" "flakes"];

        # easier to set these up now
        networking.hostName = "Foo";
        time.timeZone = "Continent/City";

        # random 8 digit hex code
        networking.hostId = "12345678";

        # set up a user
        users.users.Bar = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
            group = "Bar";

            # for installation only
            password = "test";
        };
        users.groups.Bar = {};

    # ...
    # rest of the config
    }
    ```

    `/mnt/etc/nixos/hardware-configuration.nix`

    ```nix
    {
    # rest of the config
    # ...

    boot.initrd.luks.devices = {
        root = {
            device = "/dev/disk/by-partuuid/ccc...";
            preLVM = true;
        };
    };

    # ...
    # rest of the config
    }
    ```

    > **Random encryption on swap:** In swap configuration, change the device name from `/dev/disk/by-uuid...` to `/dev/disk/by-partuuid/bbb...` and set `randomEncryption = true;`. This is needed since the uuids change on every boot with random encryption.

3. Install NixOS.

    ```console
    $ sudo nixos-install
    ```

4. Reboot into the new system.

    ```console
    $ sudo reboot
    ```

## 5. Applying configuration.

1. Once booted into the new installation, set up basic environment variables.

    ```console
    $ export NIXOS_DIR=/persist/nixos
    $ export NIXOS_ROLE=laptop
    ```

    See [this](#environment-variables) section for all variables.

2. Clone this repository.

    ```console
    $ sudo mkdir -p $NIXOS_DIR
    $ sudo chown Bar: $NIXOS_DIR
    $ nix shell nixpkgs#git --command git clone https://github.com/sotormd/nixos $NIXOS_DIR
    ```

3. Initialize variables.

    ```console
    $ export VARS_DEVICE_BOOT=$BOOT
    $ export VARS_DEVICE_SWAP=$SWAP
    $ export VARS_DEVICE_ROOT=$ROOT
    $ export VARS_USER_EMAIL=Bar@domain.com
    $ export VARS_NETWORK_SSID=BarsNetwork
    $ export VARS_NETWORK_GATEWAY=10.0.0.1
    $ export VARS_NETWORK_IP=10.0.0.20
    $ $NIXOS_DIR/scripts/nixos init vars
    ```

    See [this](#environment-variables) section for all variables.

4. Initialize secrets.

    ```console
    $ $NIXOS_DIR/scripts/nixos init sops
    ```

    It is possible to configure through environment variables.

    See [this](#environment-variables) section for all variables.

5. Edit variables/secrets.

    To ensure all variables are set, edit the variables file.

    ```console
    $ $NIXOS_DIR/scripts/nixos edit vars
    ```

    To ensure all secrets are set, edit the secrets file.

    ```console
    $ nix shell nixpkgs#sops nixpkgs#gnupg --command $NIXOS_DIR/scripts/nixos edit sops
    ```

6. Before switching to the new configuration, disable some modules that need further setup.

    1. Secure boot is not set up, so ensure `device.secureboot.enable` is set to `false` in the variables.

    2. Impermanence is not set up, so ensure `device.impermanence.enable` is set to `false` in the variables.

    ```console
    $ nixos edit vars
    ```

7. Switch to the new configuration for the first time.

    ```console
    $ nix shell nixpkgs#git --command $NIXOS_DIR/scripts/nixos switch
    ```

8. Reboot the system.

    ```console
    $ sudo reboot
    ```

    If everything goes well, you should be able to log in to `sway` from `tty1`.


9. Check that the `$NIXOS_DIR` and `$NIXOS_ROLE` environment variables are set.

    ```console
    $ nixos
    ```

    You should see a directory tree of `$NIXOS_DIR` (in this case, of `/persist/nixos`).

### Environment variables.

Full list of possible environment variables:

| Name                              | Required? | Explanation                                         | Default                                           | Example                              |
|-----------------------------------|-----------|-----------------------------------------------------|---------------------------------------------------|--------------------------------------|
| `NIXOS_DIR`                       | **Yes**   | Directory where the NixOS configuration is stored.  | -                                                 | `"/persist/nixos"`                   |
| `NIXOS_ROLE`                      | **Yes**   | `laptop` or `server` role                           | -                                                 | `"laptop"`                           |
| `VARS_DEVICE_HOSTNAME`            | No        | Hostname of the device.                             | `$(uname -n)`                                     | `"Foo"`                              |
| `VARS_DEVICE_MACHINEID`           | No        | `systemd` machine-id.                               | `$(cat /etc/machine-id)`                          | `"51934ba93b754bf28caf413f7e6c65bd"` |
| `VARS_DEVICE_HOSTID`              | No        | Host ID, required for `ZFS`.                        | `$(head -c 8 /etc/machine-id)`                    | `"51934b"`                           |
| `VARS_DEVICE_BOOT`                | **Yes**   | Boot partition partuuid.                            | -                                                 | -                                    |
| `VARS_DEVICE_SWAP`                | **Yes**   | Swap partition partuuid.                            | -                                                 | -                                    |
| `VARS_DEVICE_ROOT`                | **Yes**   | Root partition partuuid.                            | -                                                 | -                                    |
| `VARS_DEVICE_SECUREBOOT_ENABLE`   | No        | Enable secure boot.                                 | `"false"`                                         | `"true"`                             |
| `VARS_DEVICE_IMPERMANENCE_ENABLE` | No        | Enable impermanence.                                | `"false"`                                         | `"true"`                             |
| `VARS_DEVICE_PLYMOUTH_ENABLE`     | No        | Enable `plymouth` boot animations.                  | `"false"`                                         | `"true"`                             |
| `VARS_DEVICE_AUTOCPUFREQ_ENABLE`  | No        | Enable `auto-cpufreq`.                              | `"true"`                                          | `"false"`                            |
| `VARS_DEVICE_POWERTOP_ENABLE`     | No        | Enable `powertop`.                                  | `"false"`                                         | `"true"`                             |
| `VARS_DEVICE_TLP_ENABLE`          | No        | Enable `tlp`.                                       | `"false"`                                         | `"true"`                             |
| `VARS_USER_NAME`                  | No        | Username.                                           | `$USER`                                           | `"Bar"`                              |
| `VARS_USER_EMAIL`                 | **Yes**   | Email used for git commits.                         | -                                                 | `"Bar@domain.com"`                   |
| `VARS_USER_GITHUB_KEYFILE`        | No        | Github SSH identity key.                            | `"id_ed25519_github"`                             | `"id_rsa_github"`                    |
| `VARS_I18N_TIMEZONE`              | No        | Timezone.                                           | `$(timedatectl show --property=Timezone --value)` | `"Europe/Berlin"`                    |
| `VARS_I18N_KEYBOARD`              | No        | Keyboard layout.                                    | `"us"`                                            | `"us"`                               |
| `VARS_I18N_LOCALE`                | No        | Locale.                                             | `"en_US.UTF-8"`                                   | `"de_DE.UTF-8"`                      |
| `VARS_NETWORK_INTERFACE`          | No        | Wireless network interface.                         | `"wlp1s0"`                                        | `"wlan0"`                            |
| `VARS_NETWORK_SSID`               | **Yes**   | Wireless network ssid.                              | -                                                 | `"net20"`                            |
| `VARS_NETWORK_GATEWAY`            | No        | Wireless network gateway.                           | `"192.168.0.1"`                                   | `"10.0.0.0"`                         |
| `VARS_NETWORK_IP`                 | **Yes**   | Static local IP address.                            | -                                                 | `"10.0.0.3"`                         |
| `VARS_NETWORK_SERVER_ENABLE`      | No        | Enable server-dependant features.                   | `"true"`                                          | `"false"`                            |
| `VARS_NETWORK_SERVER_IP`          | **Yes***  | Static local server IP address.                     | -                                                 | `"10.0.0.5"`                         |
| `VARS_NETWORK_SERVER_DOMAIN`      | **Yes***  | Server domain.                                      | -                                                 | `"myserver.domain.com"`              |
| `VARS_NETWORK_SERVER_SSH_PORT`    | No        | Server SSH port.                                    | `"22"`                                            | `"20000"`                            |
| `VARS_NETWORK_SERVER_SSH_KEYFILE` | No        | Server SSH identity key.                            | `"id_ed25519_server"`                             | `"id_rsa"`                           |
| `VARS_NETWORK_SERVER_I2P_PORT`    | No        | Server I2P HTTP proxy port.                         | `"4444"`                                          | `"23001"`                            |
| `VARS_OUTPUTS_LAPTOP`             | No        | Identifier for laptop screen.                       | `"eDP-1"`                                         | `"eDP-1"`                            |
| `VARS_OUTPUTS_MONITOR`            | No        | Identifier for monitor screen.                      | `"HDMI-A-1"`                                      | `"HDMI-A-1"`                         |
| `VARS_OUTPUTS_WALLPAPER`          | No        | Wallpaper name.                                     | `"nord.mario"`                                    | `"nord.nixos"`                       |
| `VARS_OUTPUTS_LOCKSCREEN`         | No        | Lockscreen wallpaper name.                          | `"nord.files"`                                    | `"nord.nixos"`                       |
| `SECRETS_HASHED_PASSWORD`         | No        | Hashed user password.                               | `$(mkpasswd -m yescrypt)`                         | -                                    |
| `SECRETS_PSK`                     | No        | PSK for the network.                                | (user input)                                      | `"supersecretpsk"`                   |

*Can skip if `VARS_NETWORK_SERVER_ENABLE` is `false`.

Required section only shows the minimum variables needed to ensure a working system (ie, the rest will use defaults).

Ensure all variables are defined in the `$NIXOS_DIR/vars/vars.nix` and secrets in `$NIXOS_DIR/vars/secrets.yaml`.

## 6. Setting up Secure Boot

> WARNING: Secure Boot for NixOS is under active development. Make sure you read lanzaboote documentation before proceeding.

> WARNING: If dual booting with Windows, either disable bitlocker encryption or keep the recovery keys handy.

1. System requirements.

    Ensure you have booted in UEFI mode and Secure Boot is supported.

    ```console
    $ bootctl status
    System:
     Firmware: UEFI
    Secure Boot: disabled (disabled)
    ...
    ```

    Consider setting up a BIOS password if you haven't already.

2. Create secure boot keys.

    ```console
    $ nixos init lanzaboote create
    ```

    Set `device.secureboot.enable = true;` in `vars.nix`.
    ```console
    $ nixos edit vars
    ```

    Switch to the new configuration.
    ```console
    $ nixos switch
    ```

    Verify `sbctl verify` output.

    ```console
    $ nix shell nixpkgs#sbctl --command sudo sbctl verify
    Verifying file database and EFI images in /boot...
    ✓ /boot/EFI/BOOT/BOOTX64.EFI is signed
    ✓ /boot/EFI/Linux/nixos-generation-355.efi is signed
    ✓ /boot/EFI/Linux/nixos-generation-356.efi is signed
    ✗ /boot/EFI/nixos/0n01vj3mq06pc31i2yhxndvhv4kwl2vp-linux-6.1.3-bzImage.efi is not signed
    ✓ /boot/EFI/systemd/systemd-bootx64.efi is signed
    ```
    It is expected that `bzImage.efi` files are not signed.

3. Enter Secure Boot setup mode in BIOS.

    Boot into EFI firmware and clear existing plaform keys (setup mode).

4. Boot into NixOS and enroll Secure Boot keys.

    ```console
    $ nixos init lanzaboote enroll
    ```

5. Enable Secure Boot in BIOS.

    Boot into EFI firmware and enable Secure Boot.

    Boot into NixOS and Secure Boot should be activated and in user mode.

    ```console
    $ bootctl status
    ...
    Secure Boot: enabled (user)
    ...
    ```

## 7. Setting up impermanence.

> This section assumes Secure Boot is set up and keys are available at `/var/lib/sbctl`.

1. Populate the `/persist/` directory.

    ```console
    $ nixos init impermanence
    ```

2. Enable impermanence in configuration.

    Set `device.impermanence.enable = true;` in `vars.nix`.

    ```console
    $ nixos edit vars
    ```

3. Switch to the new configuration.

    ```console
    $ nixos switch
    ```

## 8. Adding LUKS encrypted devices

Keyfile encrypted LUKS devices can be set up via `vars.nix`

Modify the `device.luks` variable under `DEVICE VARIABLES` in `vars.nix`

```console
$ nixos edit vars
```

For example, to set up two devices `ht02` and `ht03`:

```nix
  device.luks = [
    {
        name = "ht02";
        uuid = "3f74d2e3-5a67-4b86-b2c3-842f39e45b7a";
        id = "usb-Hitachi_192939485710293857281029-0:0";
        keyfile = "/root/keys/ht02";
        mount = "/mnt/ht02";
        fs = "xfs";
        hdparm = false;
    }
    {
        name = "ht03";
        uuid = "5a67d2e3-842f-3f74-b2c3-4b8639e45b7a";
        id = "usb-Samsung_110011002933881992003918-0:0";
        keyfile = "/root/keys/ht03";
        mount = "/mnt/ht03";
        fs = "ext4";
        hdparm = false;
    }
  ];
```
