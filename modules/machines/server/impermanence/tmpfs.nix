{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.vars.features.impermanence.enable {

    fileSystems =

      lib.mkTmpRaw
        [ ]
        [
          "/usr"
        ]

      # nosuid,nodev,noexec
      // lib.mkTmpData [
        "/bin"
        "/etc"
        "/home"
        "/lib64"
        "/root"
        "/srv"
        "/var"
      ];

    # Setup /home
    systemd.services.setup-home = {
      description = "Setup /home";
      wantedBy = [ "local-fs.target" ];
      after = [ "home.mount" ];
      path = [ pkgs.coreutils-full ];
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /home/${config.vars.user.name}
        chown ${config.vars.user.name}: -R /home/${config.vars.user.name}
      '';
    };

  };

}
