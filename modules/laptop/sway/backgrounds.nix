{
  lib,
  vars,
  wallpapers,
  ...
}:

let
  # helper to resolve "nord.nixos" → wallpapers.wallpapers.nord.nixos
  getWallpaper = pathStr: lib.attrsets.getAttrFromPath (lib.splitString "." pathStr) wallpapers;
in
{
  home-manager.users.${vars.user.name} = {
    home.file = {
      ".local/share/backgrounds/wall.png".source = lib.mkForce (getWallpaper vars.outputs.wallpaper);
      ".local/share/backgrounds/lock.png".source = lib.mkForce (getWallpaper vars.outputs.lockscreen);
    };
  };
}
