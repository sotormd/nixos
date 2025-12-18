{ config, pkgs, ... }:

let
  configuration = import ./config.nix { inherit pkgs; };
  style = import ./style.nix { inherit config pkgs; };
in
{
  waybar = pkgs.writeShellScriptBin "waybar" ''
    ${pkgs.waybar}/bin/waybar --config ${configuration.config}/config --style ${style.style}/style.css "$@"
  '';
}
