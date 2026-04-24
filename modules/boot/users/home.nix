{ config, pkgs, ... }:

let
  user = config.vars.user.name;
  home = "/home/${user}";
in
{
  # Setup /home
  systemd.services.setup-home = {
    description = "Setup ${home}";
    wantedBy = [ "local-fs.target" ];
    after = [ "home.mount" ];
    path = [ pkgs.coreutils-full ];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p ${home}
      chown ${user}: -R ${home}
      chmod 700 ${home}
    '';
  };

  systemd.tmpfiles.rules = [
    "d ${home} 0700 ${user} ${user} -"
  ];
}
