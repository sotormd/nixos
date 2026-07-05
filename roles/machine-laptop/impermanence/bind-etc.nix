{ config, lib, ... }:

lib.mkIf config.vars.features.impermanence.enable {

  fileSystems =

    # nosuid, nodev, noexec
    lib.mkPersistData "/persist/root" [

      # needed by ZFS
      "/etc/zfs"

      # ssh host keys
      "/etc/ssh"

    ];

}
