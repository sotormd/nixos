{ config, lib, ... }:

lib.mkIf config.vars.features.impermanence.enable (
  lib.persistDirs "/persist/root" [
    # secure boot
    "/var/lib/sbctl"

    # needed by nixos
    "/var/lib/nixos"

    # needed by systemd
    "/var/lib/systemd"

    # needed by ZFS
    "/etc/zfs/zpool.cache"

    # logs
    "/var/log"
  ]
)
