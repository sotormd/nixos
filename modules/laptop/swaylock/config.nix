{
  lib,
  pkgs,
  colors,
  wallpapers,
  vars,
  ...
}:

let
  backgrounds = import ./backgrounds.nix { inherit lib wallpapers vars; };

  config = pkgs.writeTextFile {
    name = "config";
    text = ''
      font=${colors.fonts.normal}
      font-size=16

      image=${backgrounds.lockscreen}

      indicator-radius=200
      indicator-thickness=7

      inside-color=${colors.bg1}00
      inside-clear-color=${colors.yellow}00
      inside-ver-color=${colors.blue2}00
      inside-wrong-color=${colors.red}00
      inside-caps-lock-color=${colors.bg0}00

      ring-color=${colors.bg1}00
      ring-clear-color=${colors.yellow}
      ring-ver-color=${colors.blue2}
      ring-wrong-color=${colors.red}
      ring-caps-lock-color=${colors.bg0}00

      line-color=${colors.bg0}00
      line-clear-color=${colors.bg0}00
      line-ver-color=${colors.bg0}00
      line-wrong-color=${colors.bg0}00
      line-caps-lock-color=${colors.bg0}00
      line-uses-inside
      line-uses-ring

      layout-bg-color=${colors.bg0}00
      layout-border-color=${colors.bg0}00
      layout-text-color=${colors.bg0}00

      text-color=${colors.bg1}00
      text-clear-color=${colors.bg1}00
      text-ver-color=${colors.bg1}00
      text-wrong-color=${colors.bg1}00
      text-caps-lock-color=${colors.yellow}00

      key-hl-color=${colors.blue2}00
      bs-hl-color=${colors.yellow}00
      caps-lock-key-hl-color=${colors.bg0}00
      caps-lock-bs-hl-color=${colors.bg0}00

      separator-color=${colors.bg0}00
    '';
    destination = "/config";
  };
in
{
  configDir = pkgs.symlinkJoin {
    name = "swaylock";
    paths = [ config ];
  };
}
