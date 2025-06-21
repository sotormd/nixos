{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    home.packages = [ pkgs.tor-browser ];
  };
}
