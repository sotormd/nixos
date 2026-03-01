{ config, pkgs, ... }:

let
  inherit (import ./style.nix { inherit config pkgs; }) style;

  configuration = pkgs.writeTextFile {
    name = "rofi-config";
    text = ''
      configuration {
        location: 0;
        xoffset: 0;
        yoffset: 0;
      }
      @theme "${style}/style.rasi"
    '';
    destination = "/config.rasi";
    executable = false;
  };
in
{
  inherit configuration;
}
