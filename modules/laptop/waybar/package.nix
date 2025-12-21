{ config, pkgs, ... }:

let
  configuration = import ./config.nix { inherit pkgs; };
  style = import ./style.nix { inherit config pkgs; };
  waybarWrapped = pkgs.writeShellScriptBin "waybar" ''
    ${pkgs.waybar}/bin/waybar --config ${configuration.config}/config --style ${style.style}/style.css "$@"
  '';
in
{
  waybar = pkgs.symlinkJoin {
    name = "waybar";
    paths = [ pkgs.waybar ];

    # replace the waybar binary with our wrapper
    postBuild = ''
      rm -f $out/bin/waybar
      ln -s ${waybarWrapped}/bin/waybar $out/bin/waybar
    '';
  };
}
