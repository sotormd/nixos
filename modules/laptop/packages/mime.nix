{ config, ... }:

{
  xdg.mime.enable = true;

  xdg.mime.defaultApplications = {
    "image/png" = "swayimg.desktop";
    "image/jpeg" = "swayimg.desktop";
    "image/webp" = "swayimg.desktop";
    "image/gif" = "swayimg.desktop";

    "audio/mpeg" = "mpv.desktop";
    "audio/ogg" = "mpv.desktop";
    "audio/flac" = "mpv.desktop";
    "audio/wav" = "mpv.desktop";

    "video/mp4" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
    "video/ogg" = "mpv.desktop";

    "application/pdf" = "org.pwmt.zathura.desktop";

    "text/plain" = "mousepad.desktop";
    "text/x-shellscript" = "mousepad.desktop";
    "text/x-python" = "mousepad.desktop";
    "text/x-rustsrc" = "mousepad.desktop";
    "text/x-nix" = "mousepad.desktop";
    "text/x-c" = "mousepad.desktop";
    "text/markdown" = "mousepad.desktop";
    "application/json" = "mousepad.desktop";
    "application/x-yaml" = "mousepad.desktop";
    "application/xml" = "mousepad.desktop";

    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "image/svg+xml" = "brave-browser.desktop";

    "application/zip" = "org.gnome.FileRoller.desktop";
    "application/gzip" = "org.gnome.FileRoller.desktop";
    "application/x-tar" = "org.gnome.FileRoller.desktop";
    "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
  };

  hjem.users.${config.vars.user.name}.files = {
    ".local/share/applications/mimeapps.list".text = ''
      [Default Applications]
      image/png=swayimg.desktop
      image/jpeg=swayimg.desktop
      image/webp=swayimg.desktop
      image/gif=swayimg.desktop

      audio/mpeg=mpv.desktop
      audio/ogg=mpv.desktop
      audio/flac=mpv.desktop
      audio/wav=mpv.desktop

      video/mp4=mpv.desktop
      video/x-matroska=mpv.desktop
      video/webm=mpv.desktop
      video/ogg=mpv.desktop

      application/pdf=org.pwmt.zathura.desktop

      text/plain=mousepad.desktop
      text/x-shellscript=mousepad.desktop
      text/x-python=mousepad.desktop
      text/x-rustsrc=mousepad.desktop
      text/x-nix=mousepad.desktop
      text/x-c=mousepad.desktop
      text/markdown=mousepad.desktop
      application/json=mousepad.desktop
      application/x-yaml=mousepad.desktop
      application/xml=mousepad.desktop

      text/html=brave-browser.desktop
      x-scheme-handler/http=brave-browser.desktop
      x-scheme-handler/https=brave-browser.desktop
      image/svg+xml=brave-browser.desktop

      application/zip=org.gnome.FileRoller.desktop
      application/gzip=org.gnome.FileRoller.desktop
      application/x-tar=org.gnome.FileRoller.desktop
      application/x-7z-compressed=org.gnome.FileRoller.desktop
    '';
  };
}
