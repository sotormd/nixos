{ config, pkgs, ... }:

{
  programs.dconf.enable = true;
  users.users.${config.vars.user.name}.packages = [ pkgs.dconf ];
}
