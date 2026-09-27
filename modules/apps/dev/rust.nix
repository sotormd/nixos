{ config, pkgs, ... }:

{
  users.users.${config.vars.user.name}.packages = [
    pkgs.rustc
    pkgs.cargo
  ];
}
