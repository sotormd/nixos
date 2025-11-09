{ pkgs, vars, ... }:

{
  users.users.${vars.user.name}.packages = [
    (pkgs.makeDesktopItem {
      name = "mpv";
      desktopName = "mpv Media Player";
      genericName = "Media Player";
      comment = "A free, open source, and cross-platform media player";
      exec = "mpv %U";
      icon = "mpv";
      terminal = false;
      categories = [
        "AudioVideo"
        "Video"
        "Player"
        "TV"
      ];
      mimeTypes = [
        "audio/mpeg"
        "audio/ogg"
        "audio/flac"
        "video/mp4"
        "video/x-matroska"
        "video/x-msvideo"
        "video/quicktime"
        "application/ogg"
        "application/x-matroska"
      ];

      extraConfig = {
        StartupNotify = "false";
        Keywords = "video;audio;player;media;";
      };
    })
  ];
}
