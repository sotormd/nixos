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
    systemd.services.setup-home =
      let
        user = config.vars.user.name;
        home = "/home/${user}";
      in
      {
        description = "Setup /home";
        wantedBy = [ "local-fs.target" ];
        after = [
          "rollback-home.service"
          "home.mount"
        ];
        before = [ "hjem-activate@${user}.service" ];
        path = [ pkgs.coreutils-full ];
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p ${home}/.config
          mkdir -p ${home}/.local/share
          chown ${user}: -R /home/${user}
          chmod 700 ${home}
        '';
      };

  };
}
