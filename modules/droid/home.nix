{ pkgs, ... }:

let
  switchScript = pkgs.writeShellScriptBin "switch" ''
    #! /usr/bin/env bash

    nix-on-droid switch --flake github:sotormd/nixos
  '';

  purgeScript = pkgs.writeShellScriptBin "purge" ''
    #! /usr/bin/env bash

    nix-collect-garbage --delete-old
  '';
in
{
  imports = [ ./packages.nix ];

  home.stateVersion = "24.05";

  home.sessionVariables.NIXOS_ROLE = "droid";
  home.sessionVariables.PS1 = ''\n\[\033[1;32m\]nix \w \$\[\033[0m\] '';

  home.packages = [
    switchScript
    purgeScript
  ];
}
