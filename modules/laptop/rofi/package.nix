{ config, pkgs, ... }:

let
  configuration = import ./config.nix { inherit config pkgs; };
in
{
  rofi = pkgs.writeShellScriptBin "rofi" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${pkgs.rofi}/bin/rofi -config ${configuration.config}/config.rasi "$@"
  '';
}
