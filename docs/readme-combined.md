# NixOS Configuration Flake

~~slighly overengineered~~ NixOS configuration flake for multiple hosts.

![nixos](./docs/screenshots/nixos.gif)

Nix specific features:

- completely reproducible, pure evaluation
- dotfiles managed using wrappers implemented from basic nixpkgs functions
- symlinks in ~ managed using [hjem](https://github.com/feel-co/hjem)
- secrets managed using [sops-nix](https://github.com/Mic92/sops-nix)
- secure boot using [lanzaboote](https://github.com/nix-community/lanzaboote)
- impermanence using zfs snapshots and bind mounts
- package management using [lix](https://lix.systems)
- android environment using
  [nix-on-droid](https://github.com/nix-community/nix-on-droid)
- nixos flake helper [cli](#nixos-flake-helper)

See [Features](#features) for all features.

---

# Contents

<!--toc:start-->

- [NixOS Configuration Flake](#nixos-configuration-flake)
- [Contents](#contents)
- [Features](#features)
- [`laptop` Setup](#laptop-setup)
  - [1. Obtaining a live NixOS image.](#1-obtaining-a-live-nixos-image)
  - [2. Preparing the device.](#2-preparing-the-device)
  - [3. Partitioning disks.](#3-partitioning-disks)
  - [4. Installing NixOS.](#4-installing-nixos)
    - [Environment variables.](#environment-variables)
  - [5. Setting up Secure Boot](#5-setting-up-secure-boot)
  - [6. Setting up impermanence.](#6-setting-up-impermanence)
- [`server` Setup](#server-setup)
  - [1. Obtaining a NixOS image.](#1-obtaining-a-nixos-image)
  - [2. First boot.](#2-first-boot)
  - [3. Applying configuration.](#3-applying-configuration)
    - [Environment variables.](#environment-variables)
  - [4. Further setup.](#4-further-setup)
    - [1. nginx](#1-nginx)
    - [2. qBittorrent](#2-qbittorrent)
    - [3. Jellyfin](#3-jellyfin)
      - [Disabling media playback](#disabling-media-playback)
- [Adding External Disks](#adding-external-disks)
  - [Unencrypted Disks (device.mount)](#unencrypted-disks-devicemount)
    - [Example](#example)
  - [LUKS-Encrypted Disks (device.luks)](#luks-encrypted-disks-deviceluks)
    - [Example](#example-1)
    - [What happens automatically](#what-happens-automatically)
  - [hdparm Configuration (device.hdparm)](#hdparm-configuration-devicehdparm)
    - [Example](#example-2)
    - [What the system generates](#what-the-system-generates)
  - [Summary](#summary)
- [`droid` Setup](#droid-setup)
  - [1. Installing nix-on-droid](#1-installing-nix-on-droid)
  - [2. Applying configuration](#2-applying-configuration)
  - [3. Usage](#3-usage)
- [Images](#images)
  - [Usage](#usage)
- [`nixos` Flake Helper](#nixos-flake-helper)
  - [Command Overview](#command-overview)
  - [Updating the Lockfile](#updating-the-lockfile)
  - [Testing a New Configuration](#testing-a-new-configuration)
  - [Switching to a New Configuration](#switching-to-a-new-configuration)
  - [Committing a New Configuration](#committing-a-new-configuration)
  - [Format the Flake](#format-the-flake)
  - [Fix Flake Permissions](#fix-flake-permissions)
  - [Garbage Collect](#garbage-collect)
  - [Repair the Nix Store](#repair-the-nix-store)
  - [Push Local Changes to `server`](#push-local-changes-to-server)
  - [Edit variables / secrets.](#edit-variables-secrets)
  - [Miscellaneous](#miscellaneous)

<!--toc:end-->

---

# Features

|                               |                                                          |
| ----------------------------- | -------------------------------------------------------- |
| distro                        | `NixOS`                                                  |
| packages                      | `nixos-unstable`                                         |
| android                       | `nix-on-droid`                                           |
| package manager               | `lix`                                                    |
| secrets                       | `sops-nix` `sops`                                        |
| ~ symlinks                    | `hjem`                                                   |
| dotfiles                      | `wrappers`                                               |
| bootloader                    | `systemd-boot` `uboot`                                   |
| secureboot                    | `lanzaboote`                                             |
| kernel                        | `linux-hardened`                                         |
| auditing                      | `auditd`                                                 |
| shell                         | `bash`                                                   |
| filesystem                    | `zfs`                                                    |
| networking                    | `wpa_supplicant`                                         |
| dns                           | `unbound`                                                |
| audio                         | `pipewire`                                               |
| web server                    | `nginx`                                                  |
| media server                  | `jellyfin`                                               |
| display server                | `wayland`                                                |
| compositor                    | `swayfx`                                                 |
| bar                           | `waybar`                                                 |
| widgets                       | `eww`                                                    |
| launcher                      | `rofi`                                                   |
| notifications                 | `dunst`                                                  |
| terminal emulator             | `foot`                                                   |
| file manager                  | `thunar`                                                 |
| pdf reader                    | `zathura`                                                |
| image viewer                  | `swayimg`                                                |
| media player                  | `mpv`                                                    |
| vector graphics editor        | `inkscape`                                               |
| browser                       | `brave`                                                  |
| homepage                      | [`homepage`](https://github.com/sotormd/homepage)        |
| search engine                 | `searxng`                                                |
| bittorrent                    | `qbittorrent-nox`                                        |
| anonymity                     | `i2pd` `oniux` `tor-browser`                             |
| passwords                     | `vaultwarden`                                            |
| text editor                   | [`neovim`](https://github.com/sotormd/neovim) `mousepad` |
| version control               | `git`                                                    |
| development                   | `rust` `python` `go` `haskell`                           |
| themes, icons, cursors, fonts | [`colors`](https://github.com/sotormd/colors)            |
| wallpapers                    | [`wallpapers`](https://github.com/sotormd/wallpapers)    |
| sandboxing                    | `firejail`                                               |
| virtualization                | `qemu` `virt-manager` `distrobox`                        |
| optimizations                 | `auto-cpufreq` `tlp` `powertop`                          |
| resource monitor              | `btop` `htop`                                            |
| clipboard                     | `cliphist`                                               |
| screenshots                   | `grimshot`                                               |

---

# `laptop` Setup

Bootstrap process for the `laptop` role.

**The configuration expects a particular disk setup (covered below).**

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

   For more information, see [images](#images).

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

---

# `server` Setup

**Intended for Raspberry Pi hosts using the NixOS aarch64 sd card image.**

## 1. Obtaining a NixOS image.

1. Get a NixOS aarch64 image from
   [here](https://hydra.nixos.org/job/nixos/trunk-combined/nixos.sd_image.aarch64-linux/).

2. Verify the checksum of the image.

   ```console
   $ echo "cba2... nixos-...iso" | sha256sum --check
   ```

3. Flash this image onto an SD card after decompressing it.

## 2. First boot.

1. Boot into the SD card. You should be logged in automatically as user `nixos`.

2. Optional: disable annoying dmesg messages.

   ```console
   $ sudo dmesg -n 1
   ```

3. Generate config.

   ```console
   $ sudo nixos-generate-config
   ```

4. Edit the configuration for first rebuild.

   `/etc/nixos/configuration.nix`
   ```nix
   {
   # rest of the config
   # ...

       # enable flakes
       nix.settings.experimental-features = [ "nix-command" "flakes" ];

       # allow using nmtui
       networking.networkmanager.enable = true;

       # easier to set these up now
       networking.hostName = "Foo";
       time.timeZone = "Continent/City";

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

5. Connect to the internet.

   ```console
   $ nmtui
   ```

6. Ensure internet connection.

   ```console
   $ ping archlinux.org
   ```

7. Rebuild the configuration and reboot.

   ```console
   $ sudo nixos-rebuild switch
   $ sudo reboot
   ```

## 3. Applying configuration.

1. Once booted into the new installation, log in as the new user and set up
   basic environment variables.

   ```console
   $ export NIXOS_DIR=/nixos
   $ export NIXOS_ROLE=server
   ```

   See [this](#environment-variables) section for all variables.

2. Clone this repository.

   ```console
   $ sudo mkdir -p $NIXOS_DIR
   $ sudo chown Bar: $NIXOS_DIR
   $ nix shell nixpkgs#git --command git clone https://github.com/sotormd/nixos $NIXOS_DIR
   ```

3. Initialize variables.

   First, check `sudo blkid` output to find the root partition partuuid.

   ```console
   $ export VARS_DEVICE_ROOT=2178694e-02
   $ export VARS_USER_EMAIL=Bar@domain.com
   $ export VARS_NETWORK_SSID=BarsNetwork
   $ export VARS_NETWORK_GATEWAY=10.0.0.1
   $ export VARS_NETWORK_IP=10.0.0.20
   $ export VARS_NETWORK_RANGE=10.0.0.0/24
   $ export VARS_NETWORK_SSH_KEY=AAAA...
   $ $NIXOS_DIR/scripts/nixos init vars
   ```

   See [this](#environment-variables) section for all variables.

4. Initialize secrets.

   ```console
   $ export SECRETS_DUCKDNS_TOKEN=aaa...
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

6. Switch to the new configuration for the first time.

   ```console
   $ nix shell nixpkgs#git --command $NIXOS_DIR/scripts/nixos switch
   ```

7. Reboot the system.

   ```console
   $ sudo reboot
   ```

   If everything goes well, you should be able to log in with your new username
   and password.

8. Check that the `$NIXOS_DIR` and `$NIXOS_ROLE` environment variables are set.

   ```console
   $ nixos
   ```

   You should see a directory tree of `$NIXOS_DIR` (in this case, of `/nixos`).

9. Enable services.

   Enable required services by setting `network.<service>.enable = true;` in
   `vars.nix`.
   ```console
   $ nixos edit vars
   ```

   Switch to the new configuration.
   ```console
   $ nixos switch
   ```

### Environment variables.

Full list of possible environment variables:

| Name                                      | Explanation                                        | Default                                           | Example                              |
| ----------------------------------------- | -------------------------------------------------- | ------------------------------------------------- | ------------------------------------ |
| `NIXOS_DIR`                               | Directory where the NixOS configuration is stored. | -                                                 | `"/nixos"`                           |
| `NIXOS_ROLE`                              | `laptop` or `server` role                          | -                                                 | `"server"`                           |
| `VARS_DEVICE_HOSTNAME`                    | Hostname of the device.                            | `$(uname -n)`                                     | `"Foo"`                              |
| `VARS_DEVICE_MACHINEID`                   | `systemd` machine-id.                              | `$(cat /etc/machine-id)`                          | `"51934ba93b754bf28caf413f7e6c65bd"` |
| `VARS_DEVICE_ROOT`                        | Root partition partuuid.                           | -                                                 | -                                    |
| `VARS_USER_NAME`                          | Username.                                          | `$USER`                                           | `"Bar"`                              |
| `VARS_USER_EMAIL`                         | Email used for git commits.                        | -                                                 | `"Bar@domain.com"`                   |
| `VARS_I18N_TIMEZONE`                      | Timezone.                                          | `$(timedatectl show --property=Timezone --value)` | `"Europe/Berlin"`                    |
| `VARS_I18N_KEYBOARD`                      | Keyboard layout.                                   | `"us"`                                            | `"us"`                               |
| `VARS_I18N_LOCALE`                        | Locale.                                            | `"en_US.UTF-8"`                                   | `"de_DE.UTF-8"`                      |
| `VARS_NETWORK_INTERFACE`                  | Wireless network interface.                        | `"wlp1s0"`                                        | `"wlan0"`                            |
| `VARS_NETWORK_SSID`                       | Wireless network ssid.                             | -                                                 | `"net20"`                            |
| `VARS_NETWORK_GATEWAY`                    | Wireless network gateway.                          | `"192.168.0.1"`                                   | `"10.0.0.0"`                         |
| `VARS_NETWORK_RANGE`                      | CIDR allowed to access server.                     | `"192.168.0.0/24"`                                | `"10.0.0.0/24"`                      |
| `VARS_NETWORK_IP`                         | Static local IP address.                           | -                                                 | `"10.0.0.3"`                         |
| `VARS_NETWORK_WPA3_ENABLE`                | Enable SAE (dragonfly) authentication.             | `"true"`                                          | `"false"`                            |
| `VARS_NETWORK_DUCKDNS_DOMAIN`             | DuckDNS domain name.                               | `"$(uname -n)-server.duckdns.org"`                | `"nixos-server-0b123df.duckdns.org"` |
| `VARS_NETWORK_SSH_PORT`                   | SSH port.                                          | `"22"`                                            | `"20000"`                            |
| `VARS_NETWORK_SSH_KEY`                    | Allowed public key.                                | -                                                 | `"AAAA..."`                          |
| `VARS_NETWORK_UNBOUND_ENABLE`             | Enable Unbound.                                    | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_NGINX_ENABLE`               | Enable Nginx.                                      | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_SEARXNG_ENABLE`             | Enable SearXNG.                                    | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_VAULTWARDEN_ENABLE`         | Enable Vaultwarden.                                | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_VAULTWARDEN_DATA`           | Vaultwarden data directory.                        | `"/var/lib/bitwarden_rs"`                         | `"/mnt/drive/vaultwarden-data"`      |
| `VARS_NETWORK_VAULTWARDEN_PORT`           | Vaultwarden web vault rocket (loopback) port.      | `"8222"`                                          | `"20001"`                            |
| `VARS_NETWORK_I2PD_ENABLE`                | Enable I2PD.                                       | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_I2PD_SAM_PORT`              | I2PD SAM (loopback) port.                          | `"7656"`                                          | `"20002"`                            |
| `VARS_NETWORK_I2PD_HTTP_PROXY_PORT`       | I2PD HTTP proxy (LAN) port.                        | `"4444"`                                          | `"20003"`                            |
| `VARS_NETWORK_I2PD_SOCKS_PROXY_PORT`      | I2PD SOCKS proxy (loopback) port.                  | `"4447"`                                          | `"20004"`                            |
| `VARS_NETWORK_I2PD_WEBCONSOLE_PROXY_PORT` | I2PD webconsole (loopback) port.                   | `"7070"`                                          | `"20005"`                            |
| `VARS_NETWORK_QBT_ENABLE`                 | Enable qBittorrent.                                | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_QBT_DATA`                   | qBittorrent data directory.                        | `"/var/lib/qbt/data"`                             | `"/mnt/drive/qbt"`                   |
| `VARS_NETWORK_QBT_PORT`                   | qBittorrent webui (loopback) port.                 | `"8080"`                                          | `"20006"`                            |
| `VARS_NETWORK_JELLYFIN_ENABLE`            | Enable Jellyfin.                                   | `"false"`                                         | `"true"`                             |
| `VARS_NETWORK_JELLYFIN_PORT`              | Jellyfin web (loopback) port.                      | `"8096"`                                          | `"20007"`                            |
| `SECRETS_HASHED_PASSWORD`                 | Hashed user password.                              | `$(mkpasswd -m yescrypt)`                         | -                                    |
| `SECRETS_PSK`                             | PSK for the network.                               | (user input)                                      | `"supersecretpsk"`                   |
| `SECRETS_DUCKDNS_TOKEN`                   | DuckDNS API token.                                 | -                                                 | `"aaa..."`                           |
| `SECRETS_SEARXNG_KEY`                     | SearXNG secret key.                                | (randomly generated)                              | `"bbb..."`                           |

Ensure all relevant variables are defined in the `$NIXOS_DIR/vars/vars.nix` and
secrets in `$NIXOS_DIR/vars/secrets.yaml`.

## 4. Further setup.

#### 1. nginx

The nginx web server is hosted at `https://<your-duckdns-domain>`.

It attempts to fetch a Let's Encrypt certificate with a DNS-01 challenge using
your duckdns domain.

Reverse proxy:

|                |                       |                             |
| -------------- | --------------------- | --------------------------- |
| `/searxng`     | SearXNG               | Search engine               |
| `/vaultwarden` | Vaultwarden web vault | Password manager            |
| `/i2pd`        | I2PD web console      | Invisible Internel Protocol |
| `/qbt`         | qBittorrent webui     | Bittorrent client           |
| `/jellyfin`    | Jellyfin              | Media server                |

#### 2. qBittorrent

qBittorrent will initially start with username `admin` and a random password.
Check the service status for the password.

```console
$ systemctl status qbt
```

Then, in the web ui `https://<your-duckdns-domain>/qbt` under
`Tools > Options > WebUI > Authentication` set a username and password.

#### 3. Jellyfin

Access the web interface at `https://<your-duckdns-domain>/jellyfin` and follow
the wizard to set up your user and library.

##### Disabling media playback

If using only the `Download` and/or `Copy Stream URL` options, you can disable
media playback by disallowing it for your user.

Access the web interface at `https://<your-duckdns-domain>/jellyfin`, uncheck
`Allow media playback` under
`Dashboard > Users > <your-user> > Profile > Media Playback` and click `Save` at
the end of the page.

---

# Adding External Disks

External disks - whether **unencrypted**, **LUKS-encrypted**, or **requiring
hdparm tweaks** - can be configured declaratively through `vars.nix`.

Open the variables file:

```bash
nixos edit vars
```

All configuration happens under the `device.*` sections.

## Unencrypted Disks

Use `device.mount` to configure _plain, unencrypted_ filesystems.

Each attribute key is the mount point, and the value describes the underlying
block device.

### Example

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

## LUKS-Encrypted Disks (device.luks)

Use `device.luks` to define encrypted volumes that unlock using a keyfile.

Each entry requires:

- `uuid` - LUKS container UUID (`blkid` output)
- `keyfile` - path to keyfile
- `mount` - where the decrypted mapper device should mount
- `fs` - filesystem inside the LUKS container (`ext4`, `xfs`, etc.)

### Example

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

### What happens automatically

For each entry:

1. A `/etc/crypttab` entry is generated:

   ```
   <name> UUID=<uuid> <keyfile> luks,nofail
   ```
2. The device unlocks to `/dev/mapper/<name>`
3. A filesystem entry is created:

   ```
   fileSystems."<mount>" = {
     device = "/dev/mapper/<name>";
     fsType = "<fs>";
   };
   ```

## hdparm Configuration

Use `device.hdparm` to disable aggressive head-parking or alter disk power
behavior for HDDs.

This accepts a **list of disk IDs** (as used in `/dev/disk/by-id`).

### Example

```nix
device.hdparm = [
  "usb-WD_Elements_25A2_575852314134393745303255-0:0"
  "usb-Seagate_Expansion_1234567890ABCDEF-0:0"
];
```

### What the system generates

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

## Summary

| Feature               | Config Location | Description                              |
| --------------------- | --------------- | ---------------------------------------- |
| **Unencrypted mount** | `device.mount`  | Direct filesystem mounts                 |
| **Encrypted (LUKS)**  | `device.luks`   | Creates crypttab entries + mapper mounts |
| **hdparm tuning**     | `device.hdparm` | Generates systemd services per drive     |

---

# `droid` Setup

[nix-on-droid](https://github.com/nix-community/nix-on-droid) configuration

## 1. Installing nix-on-droid

1. Install [nix-on-droid](https://f-droid.org/packages/com.termux.nix/) from
   [FDroid](https://f-droid.org/)

2. When prompted, install with flake support.

## 2. Applying configuration

To rebuild the configuration for the first time:

```bash
nix shell nixpkgs#git --command nix-on-droid switch --flake github:sotormd/nixos
```

## 3. Usage

Switch to the new configuration at `github:sotormd/nixos`:

```bash
switch
```

Garbage collect:

```bash
purge
```

---

# Images

Two images are offered for `x86_64-linux` architectures:

1. `minimal`: A minimal NixOS environment.

2. `gnome`: NixOS with the GNOME desktop environment.

These images have experimental features `flakes` and `nix-command` enabled.

The images include several useful packages for installation, recovery, etc.

As with all NixOS installation images, the username for the live session is
`nixos` and the password is empty.

## Usage

1. `minimal` image

   ```bash
   nix run nixpkgs#nixos-generators -- \
   --format iso \
   --flake github:sotormd/nixos#imageMinimal \
   -o /tmp/minimal-image
   ```

   The resultant image will be available inside `/tmp/minimal-image/iso`.

2. `gnome` image

   ```bash
   nix run nixpkgs#nixos-generators -- \
   --format iso \
   --flake github:sotormd/nixos#imageGnome \
   -o /tmp/gnome-image
   ```

   The resultant image will be available inside `/tmp/gnome-image/iso`.

---

# `nixos` Flake Helper

Usage:

`nixos [command] [args]`

When run with **no command**, equivalent to:

`nixos tree -I .git -I .local --filesfirst`

When run with a command not listed below, the command is dispatched to
`$NIXOS_DIR`:

`nixos vi modules/common/firewall.nix`

## Command Overview

| Command             | `laptop` | `server` | Description                                                                                                      |
| ------------------- | -------- | -------- | ---------------------------------------------------------------------------------------------------------------- |
| `test`              | ✔        | ✔        | <br>`nixos test` <br>Test the current configuration.<br>Does **not** create a boot entry.                        |
| `switch`            | ✔        | ✔        | <br>`nixos switch` <br>Switch to the current configuration.<br>Creates a boot entry.                             |
| `commit`            | ✔        | ✘        | <br>`nixos commit` <br>Switch to and commit the current configuration.<br>Creates a boot entry and a Git commit. |
| `update`            | ✔        | ✔        | <br>`nixos update` <br>Update flake inputs in `flake.lock`.                                                      |
| `format`            | ✔        | ✔        | <br>`nixos format` <br>Format the flake using nixfmt.                                                            |
| `perms`             | ✔        | ✔        | <br>`nixos perms` <br>Apply correct permissions to all files in the flake.                                       |
| `purge`             | ✔        | ✔        | <br>`nixos purge` <br>Garbage collect old generations.                                                           |
| `repair`            | ✔        | ✔        | <br>`nixos repair` <br>Attempt to repair the nix store.                                                          |
| `edit <vars\|sops>` | ✔        | ✔        | <br>`nixos edit vars` <br>Edit variables file. <br><br>`nixos edit sops` <br>Edit sops-nix secrets.              |
| `serverpush <path>` | ✔        | ✘        | <br>`nixos serverpush /nixos` <br>Push the flake to `server:/nixos`.                                             |
| `help`              | ✔        | ✔        | <br>`nixos help` <br>Show this message and exit.                                                                 |

To get a basic overview of available commands:

```bash
nixos help
```

Additionally, the script is also exposed as the default package of the flake.

so running

```bash
nix run $NIXOS_DIR -- switch
```

is equivalent to

```bash
nixos switch
```

## Updating the Lockfile

To update all inputs:

```bash
nixos update
```

To update a specific input:

```bash
nixos update nixpkgs
```

To update multiple specific inputs:

```bash
nixos update nixpkgs home-manager
```

After updating the lockfile, you need to test / switch to apply changes.

To switch to the previously committed lockfile:

```bash
nixos git checkout HEAD flake.lock
```

## Testing a New Configuration

- Does **not** format the flake
- Does **not** fix flake permissions
- Switches to the new configuration
- Does **not** create a boot entry: changes are lost on reboot
- Does **not** create a git commit

```bash
nixos test
```

To skip the confirmation:

```bash
yes | nixos test
```

## Switching to a New Configuration

- Formats the flake
- Does **not** fix flake permissions
- Switches to the new configuration
- Creates a boot entry
- Does **not** create a git commit

```bash
nixos switch
```

To skip the confirmation:

```bash
yes | nixos switch
```

## Committing a New Configuration

> Not available for `server` role.

- Formats the flake
- Fixes flake permissions
- Switches to the new configuration
- Creates a boot entry
- Creates a git commit

```bash
nixos commit
```

To skip the confirmation:

```bash
yes | nixos commit
```

To mention a git commit message:

```bash
nixos commit -m "docs: update scripts.md"
```

If a message is not mentioned with the `-m` flag, the `$EDITOR` will be opened
to ask the user for a git commit message.

## Format the Flake

```bash
nixos format
```

This is equivalent to running:

```bash
nixos find . -type f -name '*.nix' -exec nix fmt {} +
```

## Fix Flake Permissions

```bash
nixos perms
```

This ensures all files are owned by `$USER`, applies `600` to all files, `700`
to all directories and `700` to all files under `$NIXOS_DIR/scripts/`.

## Garbage Collect

> WARNING: Destructive command: deletes all non-current generations.

```bash
nixos purge
```

This is equivalent to running:

```bash
sudo nix-collect-garbage --delete-old
```

## Repair the Nix Store

```bash
nixos repair
```

This is equivalent to running:

```bash
sudo nix-store --verify --check-contents --repair
```

## Push Local Changes to `server`

> Not available for `server` role.

To push to `server:/nixos`:

```bash
nixos serverpush /nixos
```

## Edit variables / secrets.

To edit variables:

```bash
nixos edit vars
```

To edit secrets:

```bash
nixos edit sops
```

If you want to recreate the variables / secrets, you can use
`nixos init <vars|sops> replace`.

## Miscellaneous

Dispatch any command to `$NIXOS_DIR`:

```bash
nixos <command>
```

For example:

Add a git remote:

```bash
nixos git remote add gh git@github.com:user/repo.git
```

Remove a git remote:

```bash
nixos git remote remove gh
```

Push to a git remote:

```bash
nixos git push gh master
```

Remove an accidental commit that hasn't been pushed yet:

```bash
nixos git reset --soft HEAD~1
```

Copy the contents of flake.nix

```bash
nixos cat flake.nix | wl-copy
```

Open an editor in the flake directory

```
nixos vi .
```
