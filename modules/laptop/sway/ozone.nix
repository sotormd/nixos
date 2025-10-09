{ vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
