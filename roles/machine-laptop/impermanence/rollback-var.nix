{
  config,
  pkgs,
  lib,
  ...
}:

lib.mkIf config.vars.features.impermanence.enable {

  # Rollback /var
  boot.initrd.systemd.services.rollback-var = {
    description = "Rollback /var";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-rpool.service" ];
    before = [ "sysroot.mount" ];
    path = [ pkgs.zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r rpool/nixos/var@blank
    '';
  };

}
