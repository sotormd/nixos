{ lib, ... }:

{
  # we don't want these directories
  environment.sessionVariables = {
    XDG_DESKTOP_DIR = null;
    XDG_DOCUMENTS_DIR = lib.mkDefault null;
    XDG_DOWNLOAD_DIR = lib.mkDefault null;
    XDG_MUSIC_DIR = null;
    XDG_PICTURES_DIR = lib.mkDefault null;
    XDG_PUBLICSHARE_DIR = null;
    XDG_TEMPLATES_DIR = null;
    XDG_VIDEOS_DIR = null;
  };
}
