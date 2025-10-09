{ pkgs, vars, ... }:

{
  imports = [
    ./config.nix
  ];

  home-manager.users.${vars.user.name} = {
    home.packages = [ pkgs.xfce.mousepad ];
  };
}
