{
  lib,
  wallpapers,
  vars,
  ...
}:

let
  # helper to resolve "nord.nixos" → wallpapers.wallpapers.nord.nixos
  getWallpaper = pathStr: lib.attrsets.getAttrFromPath (lib.splitString "." pathStr) wallpapers;
in
{
  lockscreen = getWallpaper vars.outputs.lockscreen;
}
