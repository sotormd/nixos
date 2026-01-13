{ config, pkgs, ... }:

let
  configuration = pkgs.writeTextFile {
    name = "btop.conf";
    text = ''
      color_theme = "${config.colors.btop}"
    '';
    destination = "/btop.conf";
  };
in
{
  configDir = pkgs.symlinkJoin {
    name = "btop";
    paths = [ configuration ];
  };
}
