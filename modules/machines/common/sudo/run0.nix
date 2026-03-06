{ config, pkgs, ... }:

{
  users.users.${config.vars.user.name}.packages = [
    (pkgs.writeShellScriptBin "run0" ''
      /run/current-system/sw/bin/run0 --background="1;5" "$@"
    '')
  ];
}
