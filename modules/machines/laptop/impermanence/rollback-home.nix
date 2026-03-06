{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.vars.features.impermanence.enable {

    # Rollback /home
    boot.initrd.systemd.services.rollback-home = {
      description = "Rollback /home";
      wantedBy = [ "initrd.target" ];
      after = [ "zfs-import-rpool.service" ];
      before = [ "sysroot.mount" ];
      path = [ pkgs.zfs ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        zfs rollback -r rpool/nixos/home@blank
      '';
    };

    # Setup /home
    systemd.services.setup-home = {
      description = "Setup /home";
      wantedBy = [ "local-fs.target" ];
      after = [
        "rollback-home.service"
        "home.mount"
      ];
      before = [ "hjem-activate@${config.vars.user.name}.service" ];
      path = [ pkgs.coreutils-full ];
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /home/${config.vars.user.name}/.config
        chown ${config.vars.user.name}: -R /home/${config.vars.user.name}
        chmod 700 /home/${config.vars.user.name}
      '';
    };

  };
}
