{
  lib,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    programs.firefox.profiles."i2p" = {
      name = "i2p";
      id = 0;
      isDefault = true;
      search.default = "ddg";
      search.force = true;
      search.order = lib.mkForce [ "ddg" ];
    };
  };
}
