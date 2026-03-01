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
> on the recommendations in [setup](./setup.md).

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

Then, systemd services roll back the
[root](../../modules/machines/laptop/impermanence/rollback-root.nix) and
[home](../../modules/machines/laptop/impermanence/rollback-home.nix) datasets.

So, in early boot, the `rpool/nixos/root` and `rpool/nixos/home` directories are
**completely empty**. Nix populates it with relevant files from `/nix`.

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

A lib [function](../../lib/impermanence.nix) helps avoid repeated code across
several such blocks.

Persisted directories under `/` are declared
[here](../../modules/machines/laptop/impermanence/bind-root.nix) and those under
`/home` are declared
[here](../../modules/machines/laptop/impermanence/bind-home.nix).

To persist more directories, simply add to the list. The directories under `/`
are based on the recommendations in the NixOS
[Manual](https://nixos.org/manual/nixos/stable/#ch-system-state).

At any given point, to see the files that will be thrown out by impermanence:

```console
# zfs diff rpool/root@blank
# zfs diff rpool/home@blank
```
