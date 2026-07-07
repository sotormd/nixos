# Filesystem and Impermanence

This document covers the filesystem configuration and Impermanence on the
Laptop, Server and Pi roles.

# Contents

1. [Root Filesystems](#root-filesystems)
2. [Mount Profiles](#mount-profiles)
3. [Additional Disks and Mounts](#additional-disks-and-mounts)
4. [Impermanence](#impermanence)

# Root Filesystems

## Laptop and Server

### Partitions

Three partitions are used:

1. The Boot Partition

   FAT32 partition mounted at `/boot`.

2. The Swap Partition

   Swap partition with random encryption.

3. The Root Partition

   LUKS passphrase-encrypted partition containing the ZFS `rpool`.

### ZFS Datasets

The bootstrap script creates seven datasets:

```
rpool/nixos/root       mounted at /
rpool/nixos/home       mounted at /home
rpool/nixos/var        mounted at /var
rpool/nixos/etc        mounted at /etc
rpool/nixos/srv        mounted at /srv
rpool/nixos/nix        mounted at /nix
rpool/nixos/persist    mounted at /persist
```

Five blank snapshots are also created at this time:

```
rpool/nixos/root@blank
rpool/nixos/home@blank
rpool/nixos/var@blank
rpool/nixos/etc@blank
rpool/nixos/srv@blank
```

The blank snapshots are relevant for Impermanence.

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

On Laptop and Server roles, the following directories are hardened **without
Impermanence**:

| Path                | Profile |
| ------------------- | ------- |
| `/bin`              | Data    |
| `/boot`             | Data    |
| `/etc`              | Data    |
| `/home`             | Data    |
| `/lib`              | Data    |
| `/lib64`            | Data    |
| `/persist/nixos`    | Harden  |
| `/persist/sops-nix` | Data    |
| `/root`             | Data    |
| `/srv`              | Data    |
| `/tmp`              | Data    |
| `/var`              | Data    |

On the Pi role, the following directories are hardened **without Impermanence**:

| Path                | Profile |
| ------------------- | ------- |
| `/persist`          | Harden  |
| `/persist/sops-nix` | Data    |
| `/tmp`              | Data    |

Note that Impermanence is required to harden various other directories on
Server.

Additionally, directories persisted using Impermanence are also hardened.

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
           "/var/lib/unbound" = {
             device = "/mnt/server/var/lib/unbound";
             fsType = "none";
             options = [ "bind" ];
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
           "/persist/root/var/lib/unbound" = {
             device = "/mnt/server/var/lib/unbound";
             fsType = "none";
             options = [ "bind" ];
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

## Laptop and Server

Impermanence is implemented using ZFS snapshots and bind mounts.

### ZFS Snapshots

As covered [above](#root-filesystems), the bootstrap script creates five blank
snapshots:

```
rpool/nixos/root@blank
rpool/nixos/home@blank
rpool/nixos/var@blank
rpool/nixos/etc@blank
rpool/nixos/srv@blank
```

During the Impermanence setup (post-install), the bootstrap script populates
`/persist/root` with the default directories to persist.

During early boot, systemd services roll back the `rpool/nixos/root`,
`rpool/nixos/home`, `rpool/nixos/var`, `rpool/nixos/etc` and `rpool/nixos/srv`
datasets.

So, in early boot, the `/`, `/home`, `/var`, `/etc` and `/srv` directories are
**completely empty**. Nix populates it with relevant files from `/nix` based on
the system closure. All other directories are persisted using bind mounts from
`/persist/root`. Only `/persist` and `/nix` survive across reboots.

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

```console
# zfs diff rpool/nixos/root@blank
# zfs diff rpool/nixos/home@blank
# zfs diff rpool/nixos/var@blank
# zfs diff rpool/nixos/etc@blank
# zfs diff rpool/nixos/srv@blank
```

The following directories are persisted by default:

#### Laptop

| Path                                    | Description                 | Profile |
| --------------------------------------- | --------------------------- | ------- |
| `/var/lib/nixos`                        | needed by nixos             | Data    |
| `/var/lib/systemd`                      | needed by systemd           | Data    |
| `/var/lib/sbctl`                        | secure boot keys            | Data    |
| `/var/lib/libvirt`                      | libvirt vms                 | Data    |
| `/var/log`                              | logs                        | Data    |
| `/etc/zfs`                              | needed by ZFS               | Data    |
| `/etc/ssh`                              | ssh host keys               | Data    |
| `~/Documents`                           | user documents              | Data    |
| `~/Downloads`                           | user downloaders            | Data    |
| `~/Pictures`                            | user pictures               | Data    |
| `~/Projects`                            | user projects               | Harden  |
| `~/.config/BraveSoftware/Brave-Browser` | Brave browser configuration | Harden  |
| `~/.ssh`                                | user ssh data               | Data    |
| `~/.local/share/containers`             | distrobox containers        | Raw     |

> Brave directory cannot be `noexec` since it stores Widevine executables.

> Distrobox containers directory cannot be `nosuid` since `sudo` needs to be
> usable within containers.

#### Server

| Path                    | Description             | Profile |
| ----------------------- | ----------------------- | ------- |
| `/var/lib/nixos`        | needed by nixos         | Data    |
| `/var/lib/systemd`      | needed by systemd       | Data    |
| `/var/lib/sbctl`        | secure boot keys        | Data    |
| `/var/lib/unbound`      | unbound data            | Data    |
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
[Laptop Usage Documentation](./laptop/usage.md#virtual-machines).

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
