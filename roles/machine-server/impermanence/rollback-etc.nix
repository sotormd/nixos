{
  config,
  pkgs,
  lib,
  ...
}:

lib.mkIf config.vars.features.impermanence.enable {

  # Rollback /etc
  boot.initrd.systemd.services.rollback-etc = {
    description = "Rollback /etc";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-rpool.service" ];
    before = [ "sysroot.mount" ];
    path = [ pkgs.zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r rpool/nixos/etc@blank
    '';
  };

}
