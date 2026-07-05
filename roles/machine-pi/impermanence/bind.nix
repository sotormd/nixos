{ config, lib, ... }:

lib.mkIf config.vars.features.impermanence.enable {

  fileSystems =

    # nosuid,nodev,noexec
    lib.mkPersistData "/persist/root" [

      # needed by nixos
      "/var/lib/nixos"

      # needed by systemd
      "/var/lib/systemd"

      # logs
      "/var/log"

      # needed by ZFS
      "/etc/zfs"

      # ssh host keys
      "/etc/ssh"

    ];

}
