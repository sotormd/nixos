{ config, pkgs, ... }:

{
  users.users.${config.vars.user.name}.packages = [ pkgs.file-roller ];
}
