{ config, lib, ... }:

let
  # helper to resolve "nord.nixos" → *.wallpapers.nord.nixos
  getWallpaper =
    pathStr: lib.attrsets.getAttrFromPath (lib.splitString "." pathStr) config.wallpapers;
in
{
  wallpaper = getWallpaper config.vars.outputs.wallpaper;
}
