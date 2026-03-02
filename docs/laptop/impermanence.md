# Impermanence

This document covers impermanence on the `laptop` role.

# Contents

1. [Setup](#setup)
2. [Implementation](#implementation)

# Setup

> This section assumes Secure Boot is set up and keys are available at
> `/var/lib/sbctl`.

1. Populate `/persist/` with the default directories to persist.

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
   nixos switch
   ```

# Implementation

This flake implements Impermanence without using the
[library](https://github.com/nix-community/impermanence).

This section covers the inner workings of impermanence.

## ZFS Datasets

> This section covers the ZFS datasets as created by the init script, or based
> on the recommendations in the [setup](./setup.md) documentation for the
> `laptop` role.

The init script creates four datasets:

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

During the impermanence setup (post-install), the init script copies all
relevant directories to `/persist`.

Then, systemd services roll back the `rpool/nixos/root` and `rpool/nixos/home`
datasets.

So, in early boot, the `rpool/nixos/root` and `rpool/nixos/home` directories are
**completely empty**. Nix populates it with relevant files from `/nix` based on
the system closure.

All other directories are persisted using bind mounts.

## Directories

The directories are persisted by bind-mounting them from `/persist`.

This is done by using the `fileSystems.*` options in NixOS.

An example block would look like this:

```nix
fileSystems."/path/to/thing" = {
  device = "/persist/root/path/to/thing";
  options = [ "bind" "x-gvfs-hide" ];
};
```

> `x-gvfs-hide` prevents the bind-mounts from showing up as devices in the File
> Manager.

Several helper [functions](#library-reference) are provided to make bind mounts
easily, and apply additional options using the following profiles:

| Profile   | `nosuid` | `nodev` | `noexec` | `ro` |
| --------- | -------- | ------- | -------- | ---- |
| Harden    | Yes      | Yes     | No       | No   |
| Data      | Yes      | Yes     | Yes      | No   |
| Immutable | Yes      | Yes     | No       | Yes  |
| Static    | Yes      | Yes     | Yes      | Yes  |

The following directories are persisted by default:

| Path                                    | Description                 | Profile |
| --------------------------------------- | --------------------------- | ------- |
| `/var/lib/sbctl`                        | secure boot keys            | Data    |
| `/var/lib/nixos`                        | needed by nixos             | Data    |
| `/var/lib/systemd`                      | needed by systemd           | Data    |
| `/etc/zfs/zpool.cache`                  | needed by ZFS               | Data    |
| `/var/log`                              | logs                        | Data    |
| `~/Documents`                           | user documents              | Data    |
| `~/Downloads`                           | user downloaders            | Data    |
| `~/Pictures`                            | user pictures               | Data    |
| `~/Projects`                            | user projects               | Harden  |
| `~/.config/BraveSoftware/Brave-Browser` | Brave browser configuration | Harden  |
| `~/.ssh`                                | user ssh data               | Data    |

> NOTE: Brave directory cannot be `noexec` since it stores Widevine executables.

The directories under `/` are based on the recommendations in the NixOS
[Manual](https://nixos.org/manual/nixos/stable/#ch-system-state).

At any given point, to see the files that will be thrown out by impermanence:

```console
# zfs diff rpool/root@blank
# zfs diff rpool/home@blank
```

## Library Reference

The [`lib/impermanence.nix`](../../lib/impermanence.nix) module adds several
things to `lib`, which are used throughout this flake, even in contexts other
than impermanence.

For example, the `lib.mount*` and `lib.mkLoop*` functions are used for general
filesystem hardening.

1. `lib.mountHarden`

   List of mount options for the Harden profile.

   type: `list`

   value: `[ "nosuid" "nodev" ]`

2. `lib.mountData`

   List of mount options for the Data profile.

   type: `list`

   value: `[ "nosuid" "nodev" "noexec" ]`

3. `lib.mountImmutable`

   List of mount options for the Immutable profile.

   type: `list`

   value: `[ "nosuid" "nodev" "ro" ]`

4. `lib.mountStatic`

   List of mount options for the Static profile.

   type: `list`

   value: `[ "nosuid" "nodev" "noexec" "ro" ]`

5. `lib.mkPersistRaw`

   To create raw bind mounts from `/persist/root` to `/` with custom additional
   options.

   Example:

   ```nix
   lib.mkPersistRaw [ "ro" "noexec" ] [ "/var/lib/test" "/example/dir" ];
   ```

   This bind mounts:

   - `/persist/root/var/lib/test` to `/var/lib/test` and
   - `/persist/root/example/dir` to `/example/dir`

   With the options: `[ "bind" "x-gvfs-hide" "ro" "noexec" ]`.

   The `[ "bind" "x-gvfs-hide" ]` are included by default.

6. `lib.mkPersistHarden`

   To create bind mounts from `/persist/root` to `/` with the Harden profile.

   Example:

   ```nix
   lib.mkPersistHarden [ "/opt" "/example/dir1" ];
   ```

   This bind mounts:

   - `/persist/root/opt` to `/opt` and
   - `/persist/root/example/dir1` to `/example/dir1`

   With the options: `[ "bind" "x-gvfs-hide" "nosuid" "nodev" ]`.

7. `lib.mkPersistData`

   To create bind mounts from `/persist/root` to `/` with the Data profile.

   Example:

   ```nix
   lib.mkPersistData [ "/var/lib/acme" "/var/log/audit" ];
   ```

   This bind mounts:

   - `/persist/root/var/lib/acme` to `/var/lib/acme` and
   - `/persist/root/var/log/audit` to `/var/log/audit`

   With the options: `[ "bind" "x-gvfs-hide" "nosuid" "nodev" "noexec" ]`.

8. `lib.mkPersistImmutable`

   To create bind mounts from `/persist/root` to `/` with the Immutable profile.

   Example:

   ```nix
   lib.mkPersistImmutable [ "/srv/isos" "/srv/binaries" ];
   ```

   This bind mounts:

   - `/persist/root/srv/isos` to `/srv/isos` and
   - `/persist/root/srv/binaries` to `/srv/binaries`

   With the options: `[ "bind" "x-gvfs-hide" "nosuid" "nodev" "ro" ]`.

9. `lib.mkPersistStatic`

   To create bind mounts from `/persist/root` to `/` with the Static profile.

   Example:

   ```nix
   lib.mkPersistData [ "/srv/media" "/srv/texts" "/srv/pages" ];
   ```

   This bind mounts:

   - `/persist/root/srv/media` to `/srv/media` and
   - `/persist/root/srv/texts` to `/srv/texts` and
   - `/persist/root/srv/pages` to `/srv/pages`

   With the options: `[ "bind" "x-gvfs-hide" "nosuid" "nodev" "noexec" "ro" ]`.

10. `lib.mkLoopRaw`

    To create bind mounts directories in their own location with additional
    options.

11. `lib.mkLoopHarden`

    To bind mount directories in their own location with the Harden profile.

12. `lib.mkLoopData`

    To bind mount directories in their own location with the Data profile.

13. `lib.mkLoopImmutable`

    To bind mount directories in their own location with the Immutable profile.

14. `lib.mkLoopStatic`

    To bind mount directories in their own location with the Static profile.
