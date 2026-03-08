# Filesystem and Impermanence

This document covers the filesystem configuration and Impermanence on the Laptop
and Server roles.

# Contents

1. [Available Filesystems](#available-filesystems)
2. [Root Filesystems](#root-filesystems)
3. [Mount Profiles](#mount-profiles)
4. [Additional Disks and Mounts](#additional-disks-and-mounts)
5. [Impermanence](#impermanence)

# Available Filesystems

Userspace tools for the following filesystems are available:

1. ZFS

   > Primary filesystem on the Laptop role

   See `zpool(8)`, `zfs(8)`

2. EXT4

   > Primary filesystem on the Server role

   See `ext4(5)`

3. XFS

   See `xfs(5)`

4. FAT

   See `mkfs.fat(8)`

5. NTFS

   See `ntfs-3g(8)`

# Root Filesystems

## Laptop

### Partitions

Three partitions are used:

1. The Boot Partition

   FAT32 partition mounted at `/boot`.

2. The Swap Partition

   Swap partition with random encryption.

3. The Root Partition

   LUKS passphrase-encrypted partition containing the ZFS `rpool`.

### ZFS Datasets

The bootstrap script creates four datasets:

```
rpool/nixos/nix        mounted at /nix
rpool/nixos/persist    mounted at /persist
rpool/nixos/root       mounted at /
rpool/nixos/home       mounted at /home
```

Two blank snapshots are also created at this time:

```
rpool/nixos/root@blank
rpool/nixos/home@blank
```

The blank snapshots are relevant for Impermanence.

## Server

The NixOS SD Card image disk layout is used. The root filesystem is `ext4`.

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

On the Laptop role, the following directories are hardened without Impermanence:

| Path       | Profile |
| ---------- | ------- |
| `/boot`    | Data    |
| `/home`    | Data    |
| `/persist` | Harden  |
| `/tmp`     | Harden  |
| `/bin`     | Data    |
| `/etc`     | Data    |
| `/lib64`   | Data    |
| `/root`    | Data    |
| `/srv`     | Data    |

On the Laptop role during [Nomad Mode](./laptop/usage.md#nomad-mode), the
following additional directories are hardened:

| Path                 | Profile |
| -------------------- | ------- |
| `/persist/nixos`     | Static  |
| `/persist/sops-nix`  | Static  |
| `/persist/root/home` | Static  |

On the Server role, the following directories are hardened without Impermanence:

| Path       | Profile |
| ---------- | ------- |
| `/persist` | Harden  |
| `/tmp`     | Harden  |
| `/bin`     | Data    |
| `/lib`     | Data    |
| `/lib64`   | Data    |

Additionally, directories persisted using Impermanence are also hardened
separately.

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
         uuid = "99999999-9999-9999-9999-999999999999";
         keyfile = "/root/keys/wd";
       };
      hitachi = {
         uuid = "88888888-8888-8888-8888-888888888888";
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

   Example to use an external disk for Server service data:

   ```nix
   filesystems = {
     # ...
     mount = {
       raw = { };
       harden = { };
       data = {
         "/mnt/wd" = {
           device = "/dev/mapper/wd";
           fsType = "xfs";
           options = [ "defaults" ];
         };
         "/var/lib/unbound" = {
           device = "/mnt/wd/server/var/lib/unbound";
           options = [ "bind" ];
         };
         "/var/lib/acme" = {
           device = "/mnt/wd/server/var/lib/acme";
           options = [ "bind" ];
         };
         "/var/lib/bitwarden_rs" = {
           device = "/mnt/wd/server/var/lib/bitwarden_rs";
           options = [ "bind" ];
         };
         "/var/lib/i2pd" = {
           device = "/mnt/wd/server/var/lib/i2pd";
           options = [ "bind" ];
         };
         "/var/lib/qbt" = {
           device = "/mnt/wd/server/var/lib/qbt";
           options = [ "bind" ];
         };
         "/var/lib/jellyfin" = {
           device = "/mnt/wd/server/var/lib/jellyfin";
           options = [ "bind" ];
         };
         "/srv/torrents" = {
           device = "/mnt/wd/server/srv/torrents";
           options = [ "bind" ];
         };  
       };
       immutable = { };
       static = { };
     };
   };
   ```

   **The above example is for use when Impermanence is disabled.**

   If enabled, Impermanence creates binds for all these directories from
   `/persist/root`.

   So binds must be created from the external disk to `/persist/root` instead,
   otherwise there will be mount collisions.

# Impermanence

This flake implements Impermanence without using the
[library](https://github.com/nix-community/impermanence).

This section covers the inner workings of Impermanence.

Setting up Impermanence is covered in the role-specific setup documentation:

[Laptop Setup Documentation](./laptop/setup.md#setting-up-impermanence)

[Server Setup Documentation](./server/setup.md#setting-up-impermanence)

## Laptop

Impermanence is implemented using ZFS snapshots and bind mounts.

### ZFS Snapshots

As covered [above](#root-filesystems), the bootstrap script creates two blank
snapshots:

```
rpool/nixos/root@blank
rpool/nixos/home@blank
```

During the Impermanence setup (post-install), the bootstrap script populates
`/persist/root` with the default directories to persist.

During early boot, systemd services roll back the `rpool/nixos/root` and
`rpool/nixos/home` datasets.

So, in early boot, the `rpool/nixos/root` and `rpool/nixos/home` directories are
**completely empty**. Nix populates it with relevant files from `/nix` based on
the system closure.

All directories are persisted using bind mounts from `/persist/root`.

### Persisted Directories

The directories are persisted by bind-mounting them from `/persist/root`.

This is done by using the `fileSystems.*` options in NixOS.

An example block would look like this:

```nix
fileSystems."/path/to/thing" = {
  device = "/persist/root/path/to/thing";
  options = [ "bind" "x-gvfs-hide" ];
};
```

> NOTE: `x-gvfs-hide` prevents the bind-mounts from showing up as devices in the
> File Manager.

The various helper functions covered above are used to create these bind mounts.

The following directories are persisted by default:

| Path                                    | Description                 | Profile |
| --------------------------------------- | --------------------------- | ------- |
| `/var/lib/sbctl`                        | secure boot keys            | Data    |
| `/var/lib/nixos`                        | needed by nixos             | Data    |
| `/var/lib/systemd`                      | needed by systemd           | Data    |
| `/etc/zfs`                              | needed by ZFS               | Data    |
| `/var/log`                              | logs                        | Data    |
| `~/Documents`                           | user documents              | Data    |
| `~/Downloads`                           | user downloaders            | Data    |
| `~/Pictures`                            | user pictures               | Data    |
| `~/Projects`                            | user projects               | Harden  |
| `~/.config/BraveSoftware/Brave-Browser` | Brave browser configuration | Harden  |
| `~/.ssh`                                | user ssh data               | Data    |

> NOTE: Brave directory cannot be `noexec` since it stores Widevine executables.

The directories are based on the recommendations in the NixOS
[Manual](https://nixos.org/manual/nixos/stable/#ch-system-state) and system
services.

At any given point, to see the files that will be thrown out by Impermanence:

```console
# zfs diff rpool/root@blank
# zfs diff rpool/home@blank
```

### Adding Directories

It is possible to use the variables file to add your own directories by manually
creating bind mounts as covered [above](#additional-disks-and-mounts).

Another option is to create ZFS datasets for persistent things, like `rpool/vms`
for VM disks as covered in the
[Laptop Usage Documentation](./laptop/usage.md#virtual-machines).

## Server

Impermanence is implemented using tmpfs and bind mounts.

### tmpfs Directories

The following directories are mounted as tmpfs:

| Path    | Profile |
| ------- | ------- |
| `/usr`  | Raw     |
| `/etc`  | Data    |
| `/home` | Data    |
| `/root` | Data    |
| `/srv`  | Data    |
| `/var`  | Data    |

Anything not bind mounted in these directories will not survive across reboots.
However, things in other directories will.

### Persisted Directories

During the Impermanence setup (post-install), the bootstrap script populates
`/persist/root` with the default directories to persist.

The directories are persisted by bind-mounting them from `/persist/root`.

This is done by using the `fileSystems.*` options in NixOS.

An example block would look like this:

```nix
fileSystems."/path/to/thing" = {
  device = "/persist/root/path/to/thing";
  options = [ "bind" "x-gvfs-hide" ];
};
```

> NOTE: `x-gvfs-hide` prevents the bind-mounts from showing up as devices in the
> File Manager.

The various helper functions covered above are used to create these bind mounts.

The following directories are persisted by default:

| Path                    | Description             | Profile |
| ----------------------- | ----------------------- | ------- |
| `/var/lib/sbctl`        | secure boot keys        | Data    |
| `/var/lib/nixos`        | needed by nixos         | Data    |
| `/var/lib/systemd`      | needed by systemd       | Data    |
| `/etc/zfs`              | needed by ZFS           | Data    |
| `/var/log`              | logs                    | Data    |
| `/etc/ssh`              | ssh host keys           | Data    |
| `/var/lib/fail2ban`     | fail2ban data           | Data    |
| `/var/lib/unbound`      | unbound data            | Data    |
| `/var/lib/acme`         | nginx acme certificates | Data    |
| `/var/lib/bitwarden_rs` | vaultwarden vault       | Data    |
| `/var/lib/i2pd`         | i2pd router data        | Data    |
| `/var/lib/qbt`          | qbittorrent data        | Data    |
| `/srv/torrents`         | qbittorrent torrents    | Data    |
| `/var/lib/jellyfin`     | jellyfin data           | Data    |

The directories are based on the recommendations in the NixOS
[Manual](https://nixos.org/manual/nixos/stable/#ch-system-state) and system
services.

### Adding Directories

It is possible to use the variables file to add your own directories by manually
creating bind mounts as covered [above](#additional-disks-and-mounts).
