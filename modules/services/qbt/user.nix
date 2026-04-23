{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.nginx.enable {

    users.users.qbt = {
      isSystemUser = true;
      group = "qbt";
      home = "/var/lib/qbt/home";
      createHome = true;
    };
    users.groups = {
      qbt = { };
    };

  };
}
