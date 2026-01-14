{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Rollback /
  boot.initrd.systemd.services.rollback-root = lib.mkIf config.vars.device.impermanence.enable {
    description = "Rollback /";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-rpool.service" ];
    before = [ "sysroot.mount" ];
    path = with pkgs; [ zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r rpool/root@blank
    '';
  };
}
