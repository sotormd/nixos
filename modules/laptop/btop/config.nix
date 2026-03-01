{ config, pkgs, ... }:

let
  configuration = pkgs.writeTextFile {
    name = "btop-config";
    text = ''
      color_theme = "${config.colors.btop}"
    '';
    destination = "/btop.conf";
    executable = false;
  };
in
{
  inherit configuration;
}
