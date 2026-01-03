{ pkgs, ... }:

{
  # Rollback /home
  boot.initrd.systemd.services.rollback-home = {
    description = "Rollback /home";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-rpool.service" ];
    before = [ "sysroot.mount" ];
    path = with pkgs; [ zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r rpool/home@blank
    '';
  };
}
