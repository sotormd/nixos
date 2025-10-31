{ pkgs, vars, ... }:

{
  users.users.${vars.user.name}.packages = [
    pkgs.cargo
    pkgs.rustc
  ];
}
