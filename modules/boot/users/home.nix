{ config, ... }:

let
  user = config.vars.user.name;
  home = "/home/${user}";
in
{
  systemd.tmpfiles.rules = [
    "d ${home} 0700 ${user} ${user} -"
  ];
}
