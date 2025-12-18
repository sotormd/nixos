{
  config,
  lib,
  vars,
  ...
}:

let
  # helper to resolve "nord.nixos" → *.wallpapers.nord.nixos
  getWallpaper = pathStr: lib.attrsets.getAttrFromPath (lib.splitString "." pathStr) config.wallpapers;
in
{
  lockscreen = getWallpaper vars.outputs.lockscreen;
}
