{ config, pkgs, ... }:

{
  users.users.${config.vars.user.name}.packages = [
    pkgs.cargo
    pkgs.rustc
  ];
}
