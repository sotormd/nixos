{
  config,
  lib,
  vars,
  ...
}:

let
  # helper to resolve "nord.nixos" → *.wallpapers.nord.nixos
  getWallpaper =
    pathStr: lib.attrsets.getAttrFromPath (lib.splitString "." pathStr) config.wallpapers;
in
{
  lockscreen =
    if (builtins.substring 0 4 vars.outputs.lockscreen == "xkcd") then
      config.xkcd.target
    else
      getWallpaper vars.outputs.lockscreen;
}
