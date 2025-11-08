{ pkgs, colors, ... }:

let
  config = import ./config.nix { inherit pkgs colors; };
in
{
  rofi = pkgs.writeShellScriptBin "rofi" ''
    #! ${pkgs.runtimeShell}

    ${pkgs.rofi}/bin/rofi -config ${config.config}/config.rasi "$@"
  '';
}
