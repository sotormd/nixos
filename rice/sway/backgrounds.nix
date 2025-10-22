{ lib, wallpapers, ... }:

{
  home.file = {
    ".local/share/backgrounds/wall.png".source = lib.mkDefault wallpapers.nord.mario;
    ".local/share/backgrounds/lock.png".source = lib.mkDefault wallpapers.nord.files;
  };
}
