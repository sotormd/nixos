{ config, pkgs, ... }:

{
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
      chmod 700 /home/${config.vars.user.name}
    '';
  };

  # Reset /home permissions after tmpfiles
  systemd.services.reset-home-perms = {
    description = "Reset /home permissions after tmpfiles";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-tmpfiles-setup.service" ];
    path = [ pkgs.coreutils-full ];
    serviceConfig.Type = "oneshot";
    script = ''
      chown ${config.vars.user.name}: -R /home/${config.vars.user.name}
      chmod 700 /home/${config.vars.user.name}
    '';
  };
}
