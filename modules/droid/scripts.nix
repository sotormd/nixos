{ pkgs, ... }:

let
  switchScript = pkgs.writeShellScriptBin "switch" ''
    #!/usr/bin/env bash

        nix-on-droid switch --flake github:sotormd/nixos
  '';

  cleanScript = pkgs.writeShellScriptBin "clean" ''
    #!/usr/bin/env bash

        nix-collect-garbage --delete-old
  '';
in
{
  environment.packages = [
    switchScript
    cleanScript
  ];
}
