{ config, pkgs, ... }:

let
  style = import ./style.nix { inherit config pkgs; };
in
{
  config = pkgs.writeTextFile {
    name = "config";
    text = ''
      configuration {
        location: 0;
        xoffset: 0;
        yoffset: 0;
      }
      @theme "${style.style}/style.rasi"
    '';
    destination = "/config.rasi";
  };
}
