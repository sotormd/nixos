{ pkgs, colors, ... }:

let
  config = import ./config.nix { inherit pkgs colors; };
in
{
  dunst = pkgs.writeShellScriptBin "dunst" ''
    #! ${pkgs.runtimeShell}

    ${pkgs.dunst}/bin/dunst -config ${config.configDir}/dunstrc "$@"
  '';
}
