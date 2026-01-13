{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

let
  backgrounds = import ./backgrounds.nix { inherit config lib vars; };

  configuration = pkgs.writeTextFile {
    name = "config";
    text = builtins.readFile (
      pkgs.replaceVars ./config/config {
        fontsNormal = "${config.colors.fonts.normal}";

        lockscreenBackground = "${backgrounds.lockscreen}";

        swaylockClear = "${config.colors.swaylock.clear}";
        swaylockVerifying = "${config.colors.swaylock.verifying}";
        swaylockWrong = "${config.colors.swaylock.wrong}";
      }
    );
    destination = "/config";
  };
in
{
  configDir = pkgs.symlinkJoin {
    name = "swaylock";
    paths = [ configuration ];
  };
}
