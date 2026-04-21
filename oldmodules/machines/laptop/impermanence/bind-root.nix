{ config, lib, ... }:

lib.mkIf config.vars.features.impermanence.enable {

  fileSystems =

    # nosuid, nodev, noexec
    lib.mkPersistData "/persist/root" [

      # needed by nixos
      "/var/lib/nixos"

      # needed by systemd
      "/var/lib/systemd"

      # needed by ZFS
      "/etc/zfs"

      # ssh host keys
      "/etc/ssh"

      # fail2ban data
      "/var/lib/fail2ban"

      # secure boot
      "/var/lib/sbctl"

      # libvirt virtual machines
      "/var/lib/libvirt"

      # logs
      "/var/log"

    ];

}
