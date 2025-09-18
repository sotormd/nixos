{ pkgs, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    home.packages = [ pkgs.tor-browser ];
  };
}
