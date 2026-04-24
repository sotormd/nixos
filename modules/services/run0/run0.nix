{ config, pkgs, ... }:

{
  # inverted background for run0
  users.users.${config.vars.user.name}.packages = [
    (pkgs.writeShellScriptBin "run0" ''
      /run/current-system/sw/bin/run0 --background="" "$@"
    '')
  ];

  # require password for members of wheel group
  security.run0.wheelNeedsPassword = true;

  # set a shell alias for sudo
  # do not replace the sudo package
  # we still need that probably
  environment.shellAliases.sudo = "run0";
}
