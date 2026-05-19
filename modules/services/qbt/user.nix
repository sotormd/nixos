{ config, lib, ... }:

let
  inherit (config.vars.services) qbt;
in
lib.mkIf qbt.enable {

  users.users.qbt = {
    isSystemUser = true;
    group = "qbt";
    home = "/var/lib/qbt/home";
    createHome = true;
  };
  users.groups = {
    qbt = { };
  };

}
