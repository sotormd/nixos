# Filesystem and Impermanence

This document covers the filesystem configuration and Impermanence on the
Workstation, Server and Pi roles.

# Contents

1. [Root Filesystems](#root-filesystems)
2. [Mount Profiles](#mount-profiles)
3. [Additional Disks and Mounts](#additional-disks-and-mounts)
4. [Impermanence](#impermanence)

# Root Filesystems

## Workstation and Server

### Partitions

Three partitions are used:

1. The Boot Partition

   FAT32 partition mounted at `/boot`.

2. The Swap Partition

   Swap partition with random encryption.

3. The Root Partition

   LUKS passphrase-encrypted partition containing the ZFS `rpool`.

   It is also possible to set up TPM unlocking, if required, with
   `systemd-cryptenroll`. For example, to bind to PCR 7 (Secure Boot):

   ```bash
   sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p6
   ```

### ZFS Datasets

The bootstrap script creates these datasets:

```
rpool/nixos/root       mounted at /
rpool/nixos/nix        mounted at /nix
rpool/nixos/persist    mounted at /persist
```

A blank snapshot is also created at this time:

```
rpool/nixos/root@blank
```

The blank snapshot is relevant for Impermanence.

## Pi

The upstream NixOS SD Card image disk layout is used. The root filesystem is
`ext4`.

# Mount Profiles

This flake uses mount profiles to harden mounts.

| Profile   | `nosuid` | `nodev` | `noexec` | `ro` |
| --------- | -------- | ------- | -------- | ---- |
| Raw       | No       | No      | No       | No   |
| Harden    | Yes      | Yes     | No       | No   |
| Data      | Yes      | Yes     | Yes      | No   |
| Immutable | Yes      | Yes     | No       | Yes  |
| Static    | Yes      | Yes     | Yes      | Yes  |

Several helpers are provided for internal use to make it easy to use these
profiles, for example:

1. Option lists which can be passed to `fileSystems.<name>.options` directly.

2. Helper functions to create bind mounts, or mount as `tmpfs` using these
   Profiles.

Profiles are used for Impermanence as well as general hardening without
Impermanence.

On Workstation and Server roles, the following directories are hardened **if
Impermanence is enabled**:

| Path | Profile |
| ---- | ------- |
| `/`  | Data    |

> The root can be mounted `nosuid,nodev,noexec` because, on NixOS, all
> executables that are part of the system closure come from `/nix` and all
> user-created executables are under `/persist`. Likewise, all suid binaries are
> under `/run/wrappers` which is a tmpfs. This is why it is possible if
> Impermanence is enabled.

On Workstation and Server roles, the following directories are hardened even
without Impermanence:

| Path    | Profile |
| ------- | ------- |
| `/boot` | Data    |

Additionally, directories persisted using Impermanence are also hardened
(covered below).

On Pi role, various directories are hardened if Impermanence is enabled (covered
below).

# Additional Disks and Mounts

It is possible, and recommended, to add additional disks (LUKS encrypted or
plain) and create mounts through the variables file.

To edit the variables file:

```bash
nixos edit vars
```

The `filesystem` section is used for adding disks and mounts.

1. `filesystem.luks`, for adding LUKS encrypted block devices.

   Example:

   ```nix
   filesystem = {
     luks = {
       wd = {
         uuid = "6c4261b2-d9f2-434c-ab82-17e65f809833";
         keyfile = "/root/keys/wd";
       };
      hitachi = {
         uuid = "01b3dfca-becc-4fbc-a740-f7d728435e34";
         keyfile = "/root/keys/hitachi";
       };
     };
     # ...
   };
   ```

   These drives can then be mounted as `/dev/mapper/wd` and
   `/dev/mapper/hitachi.`

2. `filesystem.mount`, for creating mounts (fstab entries)

   The mount section has five attributes:

   - `mount.raw`
   - `mount.harden`
   - `mount.data`
   - `mount.immutable`
   - `mount.static`

   These correspond to various [Mount Profiles](#mount-profiles).

   For example: by adding to `mount.static` instead of `mount.raw`,
   `[ "nosuid" "nodev" "noexec" "ro" ]` is appended to the mount `options`.

   The format of each mount is the same as the NixOS `fileSystems.*`.

   This is particularly useful on Server, where services expect specific
   directories documented in [Server Usage Documentation](./server/usage.md).

   Example with Impermanence disabled:

   ```nix
     # additional filesystem mounts
     filesystem = {

       # configure luks encrypted devices
       # each entry should have a uuid and keyfile
       luks = {
         datadisk = {
           uuid = "8b6c940c-0a09-45a5-a90d-83d465f421fd";
           keyfile = "/persist/keys/datadisk";
         };
       };

       # configure mounts
       # directly map to fileSystems.* blocks
       mount = {

         # raw mounts, no additional options
         raw = { };

         # nosuid, nodev
         harden = { };

         # nosuid, nodev, noexec
         data = {
           "/mnt/server" = {
             device = "tank/server";
             fsType = "zfs";
           };
           "/var/lib/acme" = {
             device = "/mnt/server/var/lib/acme";
             fsType = "none";
             options = [ "bind" ];
           };
           "/srv/static" = {
             device = "/mnt/server/srv/static";
             fsType = "none";
             options = [ "bind" ];
           };
           "/var/lib/bitwarden_rs" = {
             device = "/mnt/server/var/lib/bitwarden_rs";
             fsType = "none";
             options = [ "bind" ];
           };
           "/var/lib/i2pd" = {
             device = "/mnt/server/var/lib/i2pd";
             fsType = "none";
             options = [ "bind" ];
           };
           "/var/lib/qbt" = {
             device = "/mnt/server/var/lib/qbt";
             fsType = "none";
             options = [ "bind" ];
           };
           "/srv/torrents" = {
             device = "/mnt/server/srv/torrents";
             fsType = "none";
             options = [ "bind" ];
           };
         };

         # nosuid, nodev, ro
         immutable = { };

         # nosuid, nodev, noexec, ro
         static = { };

       };

     };
   ```

   **The above example is for use only when Impermanence is disabled.**

   If enabled, Impermanence creates binds for all these directories, and more,
   from `/persist/root`.

   So binds must be created from the external disk to `/persist/root` instead,
   otherwise there will be mount collisions.

   Same example but with Impermanence enabled:

   ```nix
     # additional filesystem mounts
     filesystem = {

       # configure luks encrypted devices
       # each entry should have a uuid and keyfile
       luks = {
         datadisk = {
           uuid = "8b6c940c-0a09-45a5-a90d-83d465f421fd";
           keyfile = "/persist/keys/datadisk";
         };
       };

       # configure mounts
       # directly map to fileSystems.* blocks
       mount = {

         # raw mounts, no additional options
         raw = { };

         # nosuid, nodev
         harden = { };

         # nosuid, nodev, noexec
         data = {
           "/mnt/server" = {
             device = "tank/server";
             fsType = "zfs";
           };
           "/persist/root/var/lib/acme" = {
             device = "/mnt/server/var/lib/acme";
             fsType = "none";
             options = [ "bind" ];
           };
           "/persist/root/srv/static" = {
             device = "/mnt/server/srv/static";
             fsType = "none";
             options = [ "bind" ];
           };
           "/persist/root/var/lib/bitwarden_rs" = {
             device = "/mnt/server/var/lib/bitwarden_rs";
             fsType = "none";
             options = [ "bind" ];
           };
           "/persist/root/var/lib/i2pd" = {
             device = "/mnt/server/var/lib/i2pd";
             fsType = "none";
             options = [ "bind" ];
           };
           "/persist/root/var/lib/qbt" = {
             device = "/mnt/server/var/lib/qbt";
             fsType = "none";
             options = [ "bind" ];
           };
           "/persist/root/srv/torrents" = {
             device = "/mnt/server/srv/torrents";
             fsType = "none";
             options = [ "bind" ];
           };
         };

         # nosuid, nodev, ro
         immutable = { };

         # nosuid, nodev, noexec, ro
         static = { };

       };

     };
   ```

   See the [Impermanence](#impermanence) section for full lists of directories
   are bind mounted from `/persist/root` by Impermanence.

# Impermanence

This flake implements Impermanence without using the
[library](https://github.com/nix-community/impermanence).

This section covers the inner workings of Impermanence.

Setting up Impermanence is covered in the role-specific setup documentation.

## Workstation and Server

Impermanence is implemented using ZFS snapshots and bind mounts.

### ZFS Snapshots

During the Impermanence setup (post-install), the bootstrap script populates
`/persist/root` with the default directories to persist.

During early boot, a systemd service rolls back the `rpool/nixos/root` dataset
to `rpool/nixos/root@blank`.

So, in early boot, the root filesystem is **completely empty**. Nix populates it
with relevant files from `/nix` based on the system closure. All other
directories are persisted using bind mounts from `/persist/root`. Only
`/persist` and `/nix` survive across reboots.

### Persisted Directories

During the Impermanence setup (post-install), the bootstrap script populates
`/persist/root` with the default directories to persist.

The directories are persisted by bind-mounting them from `/persist/root` using
the `fileSystems.*` options in NixOS.

The various helper functions covered above are used to create these bind mounts.

The persisted directories are based on the recommendations in the NixOS
[Manual](https://nixos.org/manual/nixos/stable/#ch-system-state) and system
services.

At any given point, to see the files that will be thrown out by Impermanence:

```bash
sudo zfs diff rpool/nixos/root@blank
```

The following directories are persisted by default:

#### Workstation

| Path                                    | Description                   | Profile |
| --------------------------------------- | ----------------------------- | ------- |
| `/var/lib/nixos`                        | needed by nixos               | Data    |
| `/var/lib/systemd`                      | needed by systemd             | Data    |
| `/var/lib/sbctl`                        | secure boot keys              | Data    |
| `/var/lib/libvirt`                      | libvirt vms                   | Data    |
| `/var/log`                              | logs                          | Data    |
| `/etc/zfs`                              | needed by ZFS                 | Data    |
| `/etc/ssh`                              | ssh host keys                 | Data    |
| `~/Documents`                           | user documents                | Data    |
| `~/Downloads`                           | user downloaders              | Data    |
| `~/Pictures`                            | user pictures                 | Data    |
| `~/Projects`                            | user projects                 | Harden  |
| `~/.config/BraveSoftware/Brave-Browser` | Brave browser configuration   | Harden  |
| `~/.ssh`                                | user ssh data                 | Data    |
| `~/.local/share/containers`             | distrobox containers          | Raw     |
| `~/.local/state/nix`                    | nix user state (eg. profiles) | Data    |

> Brave directory cannot be `noexec` since it stores Widevine executables.

> Distrobox containers directory cannot be `nosuid` since `sudo` needs to be
> usable within containers.

> Profiles created using Nix (`nix profile`, `nix-env`) are now stored under
> `XDG_STATE_HOME/nix` instead of `/nix/var/nix`. In order to keep up, we must
> persist this directory.

#### Server

| Path                    | Description             | Profile |
| ----------------------- | ----------------------- | ------- |
| `/var/lib/nixos`        | needed by nixos         | Data    |
| `/var/lib/systemd`      | needed by systemd       | Data    |
| `/var/lib/sbctl`        | secure boot keys        | Data    |
| `/var/lib/acme`         | nginx acme certificates | Data    |
| `/var/lib/bitwarden_rs` | vaultwarden vault       | Data    |
| `/var/lib/i2pd`         | i2pd router data        | Data    |
| `/var/lib/qbt`          | qbittorrent data        | Data    |
| `/var/log`              | logs                    | Data    |
| `/etc/zfs`              | needed by ZFS           | Data    |
| `/etc/ssh`              | ssh host keys           | Data    |
| `/srv/static`           | nginx static data       | Data    |
| `/srv/torrents`         | qbittorrent torrents    | Data    |

### Adding Directories

It is possible to use the variables file to add your own directories by manually
creating bind mounts as covered [above](#additional-disks-and-mounts).

Another option is to create ZFS datasets for persistent things, like `rpool/vms`
for VM disks as covered in the
[Workstation Usage Documentation](./workstation/usage.md#virtual-machines).

## Pi

Impermanence is implemented using tmpfs and bind mounts.

### tmpfs Directories

The following directories are mounted as tmpfs:

| Path     | Profile |
| -------- | ------- |
| `/bin`   | Data    |
| `/etc`   | Data    |
| `/lib`   | Data    |
| `/lib64` | Data    |
| `/home`  | Data    |
| `/root`  | Data    |
| `/srv`   | Data    |
| `/usr`   | Raw     |
| `/var`   | Data    |

Anything not bind mounted in these directories will not survive across reboots.
However, things in other directories will.

### Persisted Directories

During the Impermanence setup (post-install), the bootstrap script populates
`/persist/root` with the default directories to persist.

The directories are persisted by bind-mounting them from `/persist/root` using
the `fileSystems.*` options in NixOS.

The various helper functions covered above are used to create these bind mounts.

The persisted directories are based on the recommendations in the NixOS
[Manual](https://nixos.org/manual/nixos/stable/#ch-system-state) and system
services.

The following directories are persisted by default:

| Path               | Description       | Profile |
| ------------------ | ----------------- | ------- |
| `/var/lib/nixos`   | needed by nixos   | Data    |
| `/var/lib/systemd` | needed by systemd | Data    |
| `/var/log`         | logs              | Data    |
| `/etc/zfs`         | needed by ZFS     | Data    |
| `/etc/ssh`         | ssh host keys     | Data    |

### Adding Directories

It is possible to use the variables file to add your own directories by manually
creating bind mounts as covered [above](#additional-disks-and-mounts).
