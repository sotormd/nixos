{ pkgs, colors, ... }:

let
  config = import ./config.nix { inherit pkgs; };
  style = import ./style.nix { inherit pkgs colors; };
in
{
  waybar = pkgs.writeShellScriptBin "waybar" ''
    #! ${pkgs.runtimeShell}

    ${pkgs.waybar}/bin/waybar --config ${config.config}/config --style ${style.style}/style.css "$@"
  '';
}
