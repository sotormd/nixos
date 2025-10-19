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
  environment.packages = [
    switchScript
    purgeScript
  ];
}
