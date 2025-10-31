{ pkgs, vars, ... }:

{
  imports = [
    ./config.nix
  ];

  users.users.${vars.user.name}.packages = [ pkgs.xfce.mousepad ];
}
