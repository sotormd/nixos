{ config, pkgs, ... }:

let
  configuration = pkgs.writeTextFile {
    name = "btop.conf";
    text = builtins.readFile (
      pkgs.replaceVars ./config/btop.conf {
        color = "${config.colors.btop}";
      }
    );
    destination = "/btop.conf";
  };
in
{
  configDir = pkgs.symlinkJoin {
    name = "btop";
    paths = [ configuration ];
  };
}
