{ config, pkgs, ... }:

{
  # set of packages to appear in user environment
  users.users.${config.vars.user.name}.packages = with pkgs; [ ];
}
