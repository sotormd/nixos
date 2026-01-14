{ config, lib, ... }:

lib.mkIf config.vars.device.impermanence.enable (
  lib.persistDirs "/persist/root" [
    # Secure Boot
    "/var/lib/sbctl"

    # Needed by NixOS
    "/var/lib/nixos"

    # Needed by systemd
    "/var/lib/systemd"

    # Needed by ZFS
    "/etc/zfs/zpool.cache"

    # Logs
    "/var/log"
  ]
)
