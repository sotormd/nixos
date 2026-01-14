{ config, ... }:

{
  users.users.qbt = {
    isSystemUser = true;
    group = "qbt";
    home = "${config.vars.network.qbt.data}/qbt/home";
    createHome = true;
  };
  users.groups = {
    qbt = { };
  };
}
