{ pkgs, vars, ... }:

{
  # Rollback /
  boot.initrd.systemd.services.rollback-root = {
    description = "Rollback /";
    wantedBy = [
      "initrd.target"
    ];
    after = [
      "zfs-import-rpool.service"
    ];
    before = [
      "sysroot.mount"
    ];
    path = with pkgs; [
      zfs
    ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r rpool/root@blank
    '';
  };

  # Persist files on /
  # Secureboot
  fileSystems."/var/lib/sbctl" = {
    device = "/persist/root/var/lib/sbctl";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };

  # Needed by NixOS
  fileSystems."/var/lib/nixos" = {
    device = "/persist/root/var/lib/nixos";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };

  # Needed by systemd
  fileSystems."/var/lib/systemd" = {
    device = "/persist/root/var/lib/systemd";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };

  # Needed by ZFS
  fileSystems."/etc/zfs/zpool.cache" = {
    device = "/persist/root/etc/zfs/zpool.cache";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };

  # Logs
  fileSystems."/var/log/journal" = {
    device = "/persist/root/var/log/journal";
    options = [
      "bind"
      "x-gvfs-hide"
    ];
  };
}
