{ config, pkgs, ... }:

let
  inherit (import ./package.nix { inherit config pkgs; }) brave;
in
{
  imports = [
    ./extensions.nix

    ./policies.nix

    ./state.nix
  ];

  programs.chromium.enable = true;
  users.users.${config.vars.user.name}.packages = [ brave ];
}
