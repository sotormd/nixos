# impermanence

This flake implements Impermanence without using the
[library](https://github.com/nix-community/impermanence).

Instructions for setting up impermanence is covered in
[laptop.md](./laptop.md#setting-up-impermanence).

This document covers the inner workings of impermanence.

# Contents

1. [Implementation Details](#implementation-details)
2. [Directories](#directories)

# Implementation Details

## ZFS Datasets

> This section covers the ZFS datasets as created by the init script.

The init script creates four datasets:

```
rpool/nix
rpool/persist
rpool/root
rpool/home
```

Two blank snapshots are also created at this time:

```
rpool/root@blank
rpool/home@blank
```

During the impermanence setup (post-install), the init script copies all
relevant directories to `/persist`.

Then, systemd services roll back the
[root](../modules/laptop/impermanence/rollback-root.nix) and
[home](../modules/laptop/impermanence/rollback-home.nix) datasets.

So, in early boot, the `rpool/root` and `rpool/home` directories are
**completely empty**. Nix populates it with relevant files from `/nix`.

All other directories are persisted using bind mounts.

# Directories

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

A lib [function](../lib/impermanence.nix) helps avoid repeated code across
several such blocks.

The following directories are persisted:

- [root](../modules/laptop/impermanence/bind-root.nix): Directories under `/`
- [home](../modules/laptop/impermanence/bind-home.nix): Directories under
  `/home`

To persist more directories, simply add to the list. The directories under `/`
are based on the recommendations in the NixOS
[Manual](https://nixos.org/manual/nixos/stable/#ch-system-state).

At any given point, to see the files that will be thrown out by impermanence:

```console
# zfs diff rpool/root@blank
# zfs diff rpool/home@blank
```
