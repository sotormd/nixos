{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Rollback /home
  boot.initrd.systemd.services.rollback-home = lib.mkIf config.vars.device.impermanence.enable {
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

  # Setup /home
  systemd.services.setup-home = lib.mkIf config.vars.device.impermanence.enable {
    description = "Setup /home";
    wantedBy = [ "local-fs.target" ];
    after = [
      "rollback-home.service"
      "home.mount"
    ];
    before = [ "hjem-activate@${config.vars.user.name}.service" ];
    path = with pkgs; [ coreutils ];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /home/${config.vars.user.name}/.config
      chown ${config.vars.user.name}: -R /home/${config.vars.user.name}
    '';
  };
}
