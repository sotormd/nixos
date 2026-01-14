{ config, lib, ... }:

let
  # helper to resolve "nord.nixos" → *.wallpapers.nord.nixos
  getWallpaper =
    pathStr: lib.attrsets.getAttrFromPath (lib.splitString "." pathStr) config.wallpapers;
in
{
  lockscreen =
    if (builtins.substring 0 4 config.vars.outputs.lockscreen == "xkcd") then
      config.xkcd.target
    else
      getWallpaper config.vars.outputs.lockscreen;
}
