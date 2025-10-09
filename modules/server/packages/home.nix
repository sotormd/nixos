{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users.${vars.user.name} = {
    # set of packages to appear in user environment
    home.packages = with pkgs; [ ];
  };
}
