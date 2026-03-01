{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Rollback /
  boot.initrd.systemd.services.rollback-root = lib.mkIf config.vars.features.impermanence.enable {
    description = "Rollback /";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-rpool.service" ];
    before = [ "sysroot.mount" ];
    path = [ pkgs.zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r rpool/nixos/root@blank
    '';
  };
}
