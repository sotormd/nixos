{
  config,
  pkgs,
  lib,
  ...
}:

lib.mkIf config.vars.features.impermanence.enable {

  # Rollback /srv
  boot.initrd.systemd.services.rollback-srv = {
    description = "Rollback /srv";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-rpool.service" ];
    before = [ "sysroot.mount" ];
    path = [ pkgs.zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r rpool/nixos/srv@blank
    '';
  };

}
