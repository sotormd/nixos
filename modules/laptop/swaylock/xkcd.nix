{
  config,
  lib,
  vars,
  ...
}:

let
  type = builtins.elemAt (lib.splitString "." vars.outputs.lockscreen) 1;
  interval = builtins.elemAt (lib.choose (type == "today") "1d" "12h") 0;

  wallpaper = import ../sway/backgrounds.nix { inherit config lib vars; };
in
{
  xkcd = {
    enable = true;
    background-colors = [ config.colors.bg0 ];
    foreground-colors = [ config.colors.fg0 ];
    dimensions = "1920x1200";
    target = "/home/${vars.user.name}/.local/share/bg.png";
    fallback = wallpaper.wallpaper;
    inherit type interval;
  };
}
