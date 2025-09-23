{ vars, ... }:

{
  users.users.qbt = {
    isSystemUser = true;
    group = "qbt";
    home = "${vars.network.qbt.data}/qbt/home";
    createHome = true;
  };
  users.groups = {
    qbt = { };
  };
}
