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
  imports = [
    ./extensions.nix

    ./policies.nix
  ];

  programs.chromium.enable = true;
  users.users.${config.vars.user.name}.packages = [ brave ];
}
