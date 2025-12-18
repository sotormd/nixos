{ config, pkgs, ... }:

let
  configuration = import ./config.nix { inherit config pkgs; };
in
{
  rofi = pkgs.writeShellScriptBin "rofi" ''
    ${pkgs.rofi}/bin/rofi -config ${configuration.config}/config.rasi "$@"
  '';
}
