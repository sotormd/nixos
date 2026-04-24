{
  config,
  inputs,
  pkgs,
  ...
}:

let
  inherit (import ./package.nix { inherit config inputs pkgs; }) brave;
in
{
  programs.chromium.enable = true;
  users.users.${config.vars.user.name}.packages = [ brave ];
}
