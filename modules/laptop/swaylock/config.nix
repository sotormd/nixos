{
  config,
  lib,
  pkgs,
  ...
}:

let
  backgrounds = import ./backgrounds.nix { inherit config lib; };

  configuration = pkgs.writeTextFile {
    name = "config";
    text = ''
      font=${config.colors.fonts.normal}
      font-size=16

      image=${backgrounds.lockscreen}

      indicator-radius=90
      indicator-thickness=7

      inside-color=00000000
      inside-clear-color=00000000
      inside-ver-color=00000000
      inside-wrong-color=00000000
      inside-caps-lock-color=00000000

      ring-color=00000000
      ring-clear-color=${config.colors.swaylock.clear}
      ring-ver-color=${config.colors.swaylock.verifying}
      ring-wrong-color=${config.colors.swaylock.wrong}
      ring-caps-lock-color=00000000

      line-color=00000000
      line-clear-color=00000000
      line-ver-color=00000000
      line-wrong-color=00000000
      line-caps-lock-color=00000000
      line-uses-inside
      line-uses-ring

      layout-bg-color=00000000
      layout-border-color=00000000
      layout-text-color=00000000

      text-color=00000000
      text-clear-color=00000000
      text-ver-color=00000000
      text-wrong-color=00000000
      text-caps-lock-color=00000000

      key-hl-color=${config.colors.swaylock.verifying}
      bs-hl-color=${config.colors.swaylock.clear}
      caps-lock-key-hl-color=00000000
      caps-lock-bs-hl-color=00000000

      separator-color=00000000
    '';
    destination = "/config";
  };
in
{
  configDir = pkgs.symlinkJoin {
    name = "swaylock";
    paths = [ configuration ];
  };
}
